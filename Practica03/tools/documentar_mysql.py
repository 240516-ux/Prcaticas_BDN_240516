"""Genera diccionario y fuente Archify desde metadatos MySQL, nunca desde datos personales."""
import argparse
import csv
import html
import json
import re
from collections import Counter
from pathlib import Path

USER_COLUMN_DESCRIPTIONS = {
    'ID': 'Identificador único del usuario, asignado automáticamente.',
    'email': 'Correo electrónico único del usuario.',
    'nick': 'Alias único del usuario.',
    'password': 'Campo de credencial de la aplicación.',
    'creation_date': 'Fecha y hora en que se creó el registro.',
    'last_update': 'Fecha y hora de la última actualización del registro.',
    'last_login': 'Fecha y hora del último inicio de sesión registrado.',
    'status': 'Estado del usuario. 1 indica activo y 0 indica inactivo.',
}

# Muestras no sensibles verificadas en el respaldo propio del 2026-11-04.
BACKUP_EXAMPLES = {
    'tb_products': 'SKU: AUD-SON-00010-Y163',
    'tbc_categories': 'Categoría: Ropa',
}

# Campos públicos de tres productos del respaldo histórico propio bd_test.sql.
PRODUCT_SAMPLES = [
    (10, 'AUD-SON-00010-Y163', 'Sony Barra de sonido Smart Y163 2.1', 'Acabado gris y Dolby Audio', '6990.00', 48, 1, '2025-08-20 15:09:00', '2025-11-30 18:34:00'),
    (9, 'ENE-DUR-00009-U892', 'Duracell Regulador de voltaje Select U892 600 VA', 'Acabado plata y supresor de picos', '9059.90', 43, 1, '2024-02-05 08:47:00', '2024-10-19 08:22:00'),
    (11, 'ALM-WES-00011-X202', 'Western Digital Memoria USB Smart X202 32 GB', 'Acabado negro y formato compacto', '3709.90', 80, 1, '2023-04-04 06:56:00', '2023-11-21 06:16:00'),
]

# Proyección de campos seleccionados del respaldo propio bd_test.sql.
RECORD_SAMPLES = {
    'tb_users': (('ID', 'email', 'nick', 'password', 'creation_date', 'last_update', 'last_login', 'status'), tuple(
        (user_id, '[Oculto]', nick, '[Oculto]', '2026-10-09 16:24:22', '2026-10-09 16:24:22', None, 1)
        for user_id, nick in (
        (10, 'alan.cruz'), (11, 'marco.ramirez'), (12, 'luis.david'),
        (13, 'bryan.javier'), (14, 'ivan.ojeda'), (15, 'ivan.macin'),
        )
    )),
    'tb_products': (('ID', 'SKU', 'name', 'description (abreviada)', 'current_price', 'current_stock',
                     'status', 'creation_date', 'last_update'), PRODUCT_SAMPLES),
    'tbc_categories': (('ID', 'name', 'description', 'sup_id_category', 'status', 'creation_date', 'last_update'), tuple(
        (category_id, name, description, parent, 1, '2026-10-20 08:19:55', '2026-10-20 08:19:55')
        for category_id, name, description, parent in (
            (1, 'Ropa', 'Prendas de vestir para todas las edades y estilos.', None),
            (2, 'Hombre', 'Ropa para hombre.', 1),
            (3, 'Mujer', 'Ropa para mujer.', 1),
            (4, 'Unisex', 'Ropa y prendas sin distinción de género.', 1),
            (5, 'Caballero', 'Prendas de línea formal y casual para caballero.', 2),
            (6, 'Juvenil Hombre', 'Moda juvenil para hombre.', 2),
        )
    )),
    'tbd_products_categories': (('category_ID', 'product_ID', 'status', 'creation_date', 'last_update'), tuple(
        (1, product_id, 1, '2026-10-20 08:19:57', '2026-10-20 08:19:57')
        for product_id in (32, 47, 56, 61, 64, 92)
    )),
}

TABLE_DESCRIPTIONS = {
    'tb_buyer_orders': 'Parte de un pedido asignada a un vendedor para su preparación y entrega.',
    'tb_carts': 'Carritos asociados a usuarios.',
    'tb_logs': 'Historial de operaciones auditadas en el esquema.',
    'tb_order_cancellations': 'Cancelaciones de pedidos de vendedor.',
    'tb_orders': 'Pedidos de compradores y sus estados.',
    'tb_payment_transaction': 'Operaciones registradas para un pago.',
    'tb_payments': 'Pagos asociados a pedidos y métodos de pago.',
    'tb_people': 'Perfiles personales asociados a cuentas de la aplicación.',
    'tb_products': 'Catálogo de productos con SKU, precio actual y existencias.',
    'tb_refunds': 'Reembolsos asociados a pagos, devoluciones o cancelaciones.',
    'tb_returns': 'Devoluciones de pedidos de vendedor.',
    'tb_shipments': 'Envíos de pedidos de vendedor y su seguimiento.',
    'tb_user_addresses': 'Direcciones de entrega asociadas a usuarios.',
    'tb_users': 'Cuentas de la aplicación, identificadas por correo y alias.',
    'tbc_categories': 'Catálogo de categorías y subcategorías de productos.',
    'tbc_payment_methods_types': 'Catálogo de tipos de métodos de pago.',
    'tbd_address_components': 'Componentes de ubicación y su jerarquía.',
    'tbd_cancellation_items': 'Partidas y cantidades incluidas en una cancelación.',
    'tbd_cart_items': 'Productos, proveedores y cantidades de cada carrito.',
    'tbd_order_items': 'Partidas del pedido con cantidades e importes unitarios.',
    'tbd_products_categories': 'Asignaciones de productos a categorías.',
    'tbd_products_users_providers': 'Vínculos entre productos y usuarios proveedores.',
    'tbd_return_items': 'Partidas, cantidades y condiciones de una devolución.',
    'tbd_user_payment_methods': 'Métodos de pago asociados a usuarios.',
    'tbd_users_wishlist_products': 'Productos guardados por usuarios en su lista de deseos.',
}

FIELD_DESCRIPTIONS = {
    'id': 'Identificador del registro.',
    'subtotal': 'Importe subtotal registrado.',
    'shipping_cost': 'Importe del envío.',
    'status': 'Indicador de estado del registro.',
    'creation_date': 'Fecha y hora de creación del registro.',
    'last_update': 'Fecha y hora de la última actualización.',
    'table_name': 'Nombre de la tabla donde ocurrió la operación.',
    'table_operation': 'Tipo de operación auditada.',
    'db_user': 'Cuenta de base de datos registrada como autora de la operación.',
    'operation_description': 'Detalle guardado de la operación auditada.',
    'operation_date': 'Fecha y hora de la operación.',
    'operation_status': 'Indicador de estado de la operación auditada.',
    'record_id': 'Identificador del registro afectado.',
    'record_key': 'Clave registrada para identificar el registro afectado.',
    'actor_roles': 'Roles registrados para la cuenta que ejecutó la operación.',
    'legacy_product_log_id': 'Identificador de la entrada en la bitácora histórica de productos.',
    'reason': 'Motivo registrado para la operación.',
    'order_code': 'Código de identificación del pedido.',
    'currency': 'Código de la moneda del importe.',
    'provider': 'Proveedor del servicio de pago.',
    'transaction_ref': 'Referencia de la transacción.',
    'transaction_type': 'Tipo de operación de pago.',
    'amount': 'Importe monetario registrado.',
    'first_name': 'Nombre de la persona.',
    'last_name': 'Primer apellido de la persona.',
    'second_last_name': 'Segundo apellido de la persona.',
    'birth_date': 'Fecha de nacimiento.',
    'gender': 'Género registrado en el perfil.',
    'phone': 'Teléfono del perfil.',
    'nationality': 'Nacionalidad registrada en el perfil.',
    'sku': 'Código único de inventario del producto.',
    'name': 'Nombre visible en el catálogo.',
    'description': 'Detalle descriptivo del elemento del catálogo.',
    'current_price': 'Precio actual del producto.',
    'current_stock': 'Cantidad de unidades en inventario.',
    'carrier': 'Empresa que transporta el envío.',
    'tracking_number': 'Número de seguimiento del envío.',
    'shipped_at': 'Fecha y hora de despacho.',
    'delivered_at': 'Fecha y hora de entrega.',
    'address_label': 'Etiqueta para distinguir la dirección.',
    'recipient_name': 'Nombre de quien recibe el envío.',
    'recipient_phone': 'Teléfono de contacto del destinatario.',
    'delivery_instructions': 'Indicaciones para realizar la entrega.',
    'latitude': 'Latitud de la dirección.',
    'longitude': 'Longitud de la dirección.',
    'is_default': 'Indica si es la opción predeterminada.',
    'code': 'Código del tipo de método de pago.',
    'value': 'Valor del componente de dirección.',
    'component_type': 'Tipo de componente de la dirección.',
    'quantity': 'Cantidad de unidades de la partida.',
    'product_name': 'Nombre del producto registrado en la partida.',
    'unit_price': 'Precio por unidad registrado en la partida.',
    'type_ownership': 'Tipo de vínculo comercial entre proveedor y producto.',
    'avalaible_date': 'Fecha y hora de disponibilidad registrada.',
    'item_condition': 'Condición registrada para el artículo devuelto.',
    'provider_method_ref': 'Referencia del método en el proveedor de pagos.',
    'label': 'Etiqueta para distinguir el método de pago.',
    'last_four': 'Últimos cuatro caracteres guardados del identificador del método.',
}

def describe_column(column, references):
    table, name = column['TABLE_NAME'], column['COLUMN_NAME']
    if column.get('COLUMN_COMMENT'):
        return column['COLUMN_COMMENT']
    if table == 'tb_users' and name in USER_COLUMN_DESCRIPTIONS:
        return USER_COLUMN_DESCRIPTIONS[name]
    if references:
        return 'Vincula este registro con ' + ', '.join(references) + '.'
    if name.endswith('_status'):
        return 'Estado registrado para ' + {
            'fulfillment_status': 'la preparación y entrega del pedido',
            'cancellation_status': 'la cancelación',
            'order_status': 'el pedido',
            'transaction_status': 'la transacción',
            'payment_status': 'el pago',
            'refund_status': 'el reembolso',
            'return_status': 'la devolución',
            'shipment_status': 'el envío',
        }.get(name, 'el registro') + '.'
    return FIELD_DESCRIPTIONS.get(name.lower(), f"Campo {name} de tipo {column['COLUMN_TYPE']}.")

def render_dictionary(metadata, entities, rows, fk_count, view_count, snapshot=None):
    def esc(value):
        return html.escape('NULL' if value is None else str(value))

    labels = {'Catalogo': 'Catálogo', 'Auditoria': 'Auditoría'}
    colors = ['#b6a2ff', '#65d9ea', '#8dddac', '#ffc374', '#ffa9ce', '#f1d48a', '#a0b7da']
    tags = list(dict.fromkeys(entity['tag'] for entity in entities))
    counts = snapshot['counts'] if snapshot else {}
    fmt = lambda value: f'{value:,}'.replace(',', ' ')
    results = ''
    if snapshot:
        names = {e['id'] for e in entities}
        if snapshot['schema'] != metadata['schema'] or set(counts) != names or any(
            type(n) is not int or n < 0 for n in counts.values()
        ):
            raise ValueError('Los conteos deben cubrir exactamente las tablas del esquema.')
        results = (
            '<details id="resultados" class="panel"><summary>Totales de estructura y registros</summary>'
            f'<p>{esc(snapshot["origen"])} · {esc(snapshot["fecha"])}</p>'
            f'<p>{fmt(sum(counts.values()))} filas sumadas entre todas las tablas físicas. '
            f'Incluye {fmt(counts["tb_people"])} perfiles y {fmt(counts["tb_logs"])} entradas de bitácora.</p>'
            f'<p>{len(rows)} columnas · {fk_count} claves foráneas · {view_count} vistas.</p></details>'
        )
    accents = dict(zip(tags, colors))
    by_table = {}
    for row in rows:
        by_table.setdefault(row[1], []).append(row)
    totals = [('Tablas', len(entities)), ('Columnas', len(rows)), ('Claves foráneas', fk_count)]
    if 'triggers' in metadata:
        totals += [('Vistas', view_count), ('Triggers', len(metadata['triggers']))]
    if snapshot:
        totals = [('Tablas', len(entities)), ('Triggers', len(metadata['triggers'])),
                  ('Productos', counts['tb_products']), ('Usuarios', counts['tb_users'])]
    inventory, sections, overview = [], [], []
    trigger_counts = Counter(t['EVENT_OBJECT_TABLE'] for t in metadata.get('triggers', []))
    headings = ['Nombre del campo', 'Tipo de dato', 'Llave (PK/FK)', 'Nulo (Sí/No)',
                'Descripción / lógica']
    header = ''.join(f'<th scope="col">{label}</th>' for label in headings)
    foreign_keys = {}
    for key in metadata['foreign_keys']:
        foreign_keys.setdefault((key['TABLE_NAME'], key['COLUMN_NAME']), []).append(
            f"{key['REFERENCED_TABLE_NAME']}.{key['REFERENCED_COLUMN_NAME']}"
        )
    for i, entity in enumerate(entities):
        name, tag = entity['id'], entity['tag']
        table_rows = by_table[name]
        count = counts.get(name)
        count_label = f' · {fmt(count)} filas' if count is not None else ''
        primary_keys = int(any(row[6] == 'PRI' for row in table_rows))
        foreign_key_count = len({k['CONSTRAINT_NAME'] for k in metadata['foreign_keys'] if k['TABLE_NAME'] == name})
        sample = BACKUP_EXAMPLES.get(name)
        example = sample or ('Tabla vacía en el conteo del VPS' if count == 0 else 'Muestra no publicada')
        overview.append(
            f'<tr><td><a href="#{esc(name)}" data-open-table="{esc(name)}"><code>{esc(name)}</code></a></td>'
            f'<td>{esc(labels.get(tag, tag))}</td><td>{len(table_rows)}</td>'
            f'<td>{fmt(count) if count is not None else "—"}</td>'
            f'<td>{primary_keys}</td><td>{foreign_key_count}</td>'
            f'<td>{esc(example)}</td></tr>'
        )
        inventory.append(f'<li><button type="button" data-table="{esc(name)}">{esc(name)} · {len(table_rows)} columnas{count_label}</button></li>')
        body = []
        attributes = {attribute['name']: attribute for attribute in entity['attributes']}
        for _, _, column, sql_type, nullable, default, _, extra, _, description in table_rows:
            roles = attributes[column].get('key', [])
            if isinstance(roles, str):
                roles = [roles]
            badges = ' '.join(f'<span class="key">{esc(role.upper())}</span>' for role in roles) or '—'
            default_value = 'Sin predeterminado' if default is None and nullable == 'NO' else esc(default)
            logic = [f'<span>{esc(description)}</span>',
                     f'<small>Predeterminado <code>{default_value}</code></small>']
            refs = foreign_keys.get((name, column), [])
            if refs:
                logic.append(f'<small>Referencia <code>{esc(", ".join(refs))}</code></small>')
            if extra:
                logic.append(f'<small>Extra <code>{esc(extra)}</code></small>')
            body.append(
                f'<tr><th scope="row"><code>{esc(column)}</code></th>'
                f'<td><code>{esc(sql_type)}</code></td><td>{badges}</td>'
                f'<td>{"Sí" if nullable == "YES" else "No"}</td>'
                f'<td class="field-logic">{"".join(logic)}</td></tr>'
            )
        opened = ' open' if i == 0 else ''
        pk_fields = sum(row[6] == 'PRI' for row in table_rows)
        fk_fields = sum((name, row[2]) in foreign_keys for row in table_rows)
        required_fields = sum(row[4] == 'NO' for row in table_rows)
        metrics = [('Campos', len(table_rows)), ('Filas del VPS', fmt(count) if count is not None else '—'),
                   ('Campos PK', pk_fields), ('Campos FK', fk_fields), ('NOT NULL', required_fields)]
        stats = ''.join(f'<div class="kpi"><b>{value}</b><span>{label}</span></div>'
                        for label, value in metrics)
        records_html = f'<h3>Datos de <code>{esc(name)}</code></h3>'
        if name in RECORD_SAMPLES:
            record_columns, records = RECORD_SAMPLES[name]
            record_header = ''.join(f'<th scope="col">{esc(label)}</th>' for label in record_columns)
            record_rows = ''.join('<tr>' + ''.join(f'<td>{esc(value)}</td>' for value in record)
                                  + '</tr>' for record in records)
            records_html += (
                '<p class="sample-source">Muestra histórica de tu respaldo <code>bd_test.sql</code>. '
                'Los datos sensibles aparecen como [Oculto].</p>'
                '<div class="record-sample">'
                '<label>Buscar en esta muestra <input type="search"></label>'
                f'<p role="status">Mostrando {len(records)} de {len(records)} filas de la muestra.</p>'
                f'<div class="scroll"><table aria-label="Muestra de {esc(name)}">'
                f'<thead><tr>{record_header}</tr></thead><tbody>{record_rows}</tbody></table></div>'
                '<div class="sample-pages"><button type="button" data-step="-1">Anterior</button>'
                '<button type="button" data-step="1">Siguiente</button></div></div>'
            )
        elif count == 0:
            records_html += '<p>0 filas en el conteo del VPS.</p>'
        elif name == 'tb_people':
            records_html += '<p>El conteo del VPS incluye los perfiles. Sus datos personales se mantienen privados.</p>'
        else:
            records_html += '<p>Conteo disponible arriba. Esta tabla no tiene una muestra publicada.</p>'
        sections.append(
            f'<details class="table-card" id="{esc(name)}" data-module="{esc(tag)}" '
            f'style="--module:{accents[tag]}"{opened}>'
            f'<summary><code>{esc(name)}</code><span>{esc(labels.get(tag, tag))} · {len(table_rows)} columnas</span>'
            + (f'<strong class="row-count">{fmt(count)} filas</strong>' if count is not None else '')
            + '</summary>'
            f'<div class="table-overview"><p>{esc(TABLE_DESCRIPTIONS[name])}</p>'
            f'<div class="kpis">{stats}</div>{records_html}</div>'
            f'<details class="field-details"><summary>Ver los {len(table_rows)} campos del diccionario</summary>'
            f'<div class="scroll"><table aria-label="Columnas de {esc(name)}"><thead><tr>{header}</tr></thead>'
            f'<tbody>{"".join(body)}</tbody></table></div></details></details>'
        )
    constraints = ''.join(
        f'<details class="constraints"><summary>{label}</summary>'
        f'<pre><code>{esc(json.dumps(metadata[key], ensure_ascii=False, indent=2))}</code></pre></details>'
        for key, label in [('indexes', 'Índices'), ('foreign_keys', 'Claves foráneas'),
                           ('checks', 'Restricciones CHECK')]
    )
    replacements = {
        '__SOURCE__': esc(f"{metadata['entorno']} · MySQL {metadata['version']} · Exportación del {metadata['fecha']}"),
        '__TOTALS__': ''.join(f'<div class="kpi"><b>{value}</b><span>{label}</span></div>' for label, value in totals),
        '__MODULES__': ''.join(f'<option value="{esc(tag)}">{esc(labels.get(tag, tag))}</option>' for tag in tags),
        '__INVENTORY__': ''.join(inventory),
        '__TABLES__': '\n'.join(sections),
        '__CONSTRAINTS__': constraints,
        '__RESULTS__': results,
        '__RESULTSLINK__': '<a href="#resultados">Resultados del VPS</a>' if snapshot else '',
        '__OVERVIEW__': ''.join(overview),
    }
    template = Path(__file__).with_name('diccionario_bd_test.html').read_text(encoding='utf-8')
    return re.sub(r'__[A-Z]+__', lambda match: replacements[match.group()], template)


def render_atlas(metadata, entities, rows, grouped, views):
    fields = {}
    for _, table, column, sql_type, nullable, default, key, _, references, _ in rows:
        fields.setdefault(table, []).append(
            [column, sql_type, nullable, default, key or '—', references or '—']
        )
    mermaid = ['erDiagram', '    direction LR']
    for entity in entities:
        mermaid.append(f"    {entity['id']} {{")
        for attribute in entity['attributes']:
            sql_type = attribute['type']
            # Mermaid accepts a restricted token for types. Keep the full SQL type as a comment.
            token = re.match(r'[a-zA-Z0-9_]+', sql_type).group()
            keys = attribute.get('key', [])
            keys = [keys] if isinstance(keys, str) else keys
            roles = ','.join(key.upper() for key in keys)
            comment = sql_type.replace('"', "'")
            mermaid.append(f'        {token} {attribute["name"]} {roles} "{comment}"')
        mermaid.append('    }')
    relationships = []
    for (child, name, parent), keys in grouped.items():
        child_columns = [k['COLUMN_NAME'] for k in keys]
        parent_columns = [k['REFERENCED_COLUMN_NAME'] for k in keys]
        fields_by_name = {f[0]: f for f in fields[child]}
        nullable = any(fields_by_name[col][2] == 'YES' for col in child_columns)
        unique_indexes = {}
        for index in metadata['indexes']:
            if index['TABLE_NAME'] == child and index['NON_UNIQUE'] == 0:
                unique_indexes.setdefault(index['INDEX_NAME'], []).append(index)
        unique = any(
            {i['COLUMN_NAME'] for i in index} <= set(child_columns)
            for index in unique_indexes.values()
        )
        identifying = all(fields_by_name[col][4] == 'PRI' for col in child_columns)
        parent_cardinality = '|o' if nullable else '||'
        child_cardinality = 'o|' if unique else 'o{'
        line = '--' if identifying else '..'
        label = f"{name} ({', '.join(child_columns)} → {', '.join(parent_columns)})"
        mermaid.append(f'    {parent} {parent_cardinality}{line}{child_cardinality} {child} : "{label}"')
        relationships.append({'from': child, 'to': parent})
    payload = {
        'source': f"{metadata['entorno']} · MySQL {metadata['version']} · {metadata['fecha']}",
        'totals': {'Tablas': len(entities), 'Columnas': len(rows),
                   'Claves foráneas': len(relationships), 'Vistas': views,
                   'Triggers': len(metadata.get('triggers', []))},
        'tables': [{'id': e['id'], 'tag': e['tag'], 'fields': fields[e['id']]} for e in entities],
        'relationships': relationships,
        'mermaid': '\n'.join(mermaid),
    }
    template = Path(__file__).with_name('visor_bd_test.html').read_text(encoding='utf-8')
    return template.replace('__ATLAS_DATA__', json.dumps(payload, ensure_ascii=False).replace('<', '\\u003c'))


def generate(metadata_path, counts_path=None):
    p = Path(__file__).resolve().parents[1]
    out = p / 'docs'
    out.mkdir(exist_ok=True)
    raw = metadata_path.read_text(encoding='utf-8-sig').strip()
    if raw.startswith("'{") and raw.endswith("}'"):
        raw = raw[1:-1].replace("''", "'")
    d = json.loads(raw)
    columns = sorted(d['columns'], key=lambda c: (c['TABLE_NAME'], c['ORDINAL_POSITION']))
    fks = sorted(d['foreign_keys'], key=lambda k: (k['TABLE_NAME'], k['CONSTRAINT_NAME'], k['ORDINAL_POSITION']))
    base_tables = {t['TABLE_NAME'] for t in d['tables'] if t['TABLE_TYPE'] == 'BASE TABLE'}
    views = sum(t['TABLE_TYPE'] == 'VIEW' for t in d['tables'])
    totals = f"{len(base_tables)} tablas, {len(columns)} columnas y {len({(k['TABLE_NAME'], k['CONSTRAINT_NAME']) for k in fks})} claves foráneas"
    if views:
        totals += f", {views} vistas y {len(d['triggers'])} triggers"
    refs = {}
    for k in fks:
        refs.setdefault((k['TABLE_NAME'], k['COLUMN_NAME']), []).append(
            k['REFERENCED_TABLE_NAME'] + '.' + k['REFERENCED_COLUMN_NAME'])
    rows = []
    for c in columns:
        column_refs = refs.get((c['TABLE_NAME'], c['COLUMN_NAME']), [])
        description = describe_column(c, column_refs)
        rows.append([d['schema'], c['TABLE_NAME'], c['COLUMN_NAME'], c['COLUMN_TYPE'],
                     c['IS_NULLABLE'], c['COLUMN_DEFAULT'], c['COLUMN_KEY'], c['EXTRA'],
                     ', '.join(refs.get((c['TABLE_NAME'], c['COLUMN_NAME']), [])), description])
    header = ['esquema', 'tabla', 'columna', 'tipo', 'admite_null', 'predeterminado', 'clave', 'extra', 'referencias', 'descripcion']
    with (out / 'diccionario_datos.csv').open('w', encoding='utf-8-sig', newline='') as stream:
        writer = csv.writer(stream); writer.writerow(header); writer.writerows(rows)
    domains={
        'Identidad': ['tb_users','tb_people','tb_user_addresses','tbd_address_components'],
        'Catalogo': ['tb_products','tbc_categories','tbd_products_categories','tbd_products_users_providers','tbd_users_wishlist_products'],
        'Carritos': ['tb_carts','tbd_cart_items'],
        'Pedidos': ['tb_orders','tb_buyer_orders','tbd_order_items','tb_shipments'],
        'Pagos': ['tbc_payment_methods_types','tbd_user_payment_methods','tb_payments','tb_payment_transaction'],
        'Posventa': ['tb_order_cancellations','tbd_cancellation_items','tb_returns','tbd_return_items','tb_refunds'],
        'Auditoria': ['tb_logs'],
    }
    positions = {
        'Identidad': (0, 0), 'Carritos': (4, 0), 'Auditoria': (6, 0),
        'Catalogo': (0, 1), 'Pedidos': (0, 2),
        'Posventa': (4, 2), 'Pagos': (0, 3),
    }
    entities=[]; guided=[]
    # UK marca participacion en clave unica, no unicidad individual de cada componente.
    unique={(i['TABLE_NAME'],i['COLUMN_NAME']) for i in d['indexes'] if i['NON_UNIQUE']==0 and i.get('COLUMN_NAME')}
    for domain,tables in domains.items():
        start,col=positions[domain]
        if domain not in ('Carritos','Auditoria'):
            guided.append({'id':domain.lower(),'label':domain,'focus':list(tables),'note':'Tablas del dominio '+domain+'.'})
        for offset,table in enumerate(tables):
            attributes=[]
            for c in columns:
                if c['TABLE_NAME']!=table: continue
                a={'name':c['COLUMN_NAME'],'type':c['COLUMN_TYPE']};roles=[]
                if c['COLUMN_KEY']=='PRI':roles.append('pk')
                if (table,c['COLUMN_NAME']) in refs:
                    roles.append('fk');a['references']=refs[(table,c['COLUMN_NAME'])][0]
                if (table,c['COLUMN_NAME']) in unique and 'pk' not in roles:roles.append('uk')
                if roles:a['key']=roles[0] if len(roles)==1 else roles
                attributes.append(a)
            width=round(max(280,len(table)*7+75,max(len(a['name'])*6.6+len(a['type'])*6.8+100 for a in attributes)))
            entities.append({'id':table,'label':table,'tag':domain,'row':start+offset,'col':col,'width':width,'attributes':attributes})
    relationships=[]; grouped={}
    for fk in fks:grouped.setdefault((fk['TABLE_NAME'],fk['CONSTRAINT_NAME'],fk['REFERENCED_TABLE_NAME']),[]).append(fk)
    for n,((child,name,parent),keys) in enumerate(grouped.items()):
        target=parent
        if child==parent:
            # El renderer no admite autoaristas. Se conserva la FK en los campos
            # y se explica completa en la tarjeta; no se dibuja una tabla ficticia.
            continue
        childcols=[k['COLUMN_NAME'] for k in keys]
        nullable=any(c['IS_NULLABLE']=='YES' for c in columns if c['TABLE_NAME']==child and c['COLUMN_NAME'] in childcols)
        indexes={}
        for i in d['indexes']:
            if i['TABLE_NAME']==child and i['NON_UNIQUE']==0:indexes.setdefault(i['INDEX_NAME'],[]).append(i)
        is_unique=any([x['COLUMN_NAME'] for x in sorted(v,key=lambda x:x['SEQ_IN_INDEX'])]==childcols for v in indexes.values())
        identifying=all(next(c for c in columns if c['TABLE_NAME']==child and c['COLUMN_NAME']==k)['COLUMN_KEY']=='PRI' for k in childcols)
        rel={'id':'fk'+str(n+1),'from':child,'to':target,'fromCardinality':'one' if is_unique else 'many','toCardinality':'one','fromOptional':True,'toOptional':nullable,'identifying':identifying}
        if not identifying:rel['variant']='dashed'
        relationships.append(rel)
    next(v for v in guided if v['id']=='identidad')['focus']+=domains['Carritos']
    next(v for v in guided if v['id']=='pagos')['focus']+=domains['Auditoria']
    if {e['id'] for e in entities} != base_tables:
        raise ValueError('El inventario de tablas cambió. Actualiza los dominios del MERE.')
    self_refs = [
        f"{child}.({', '.join(k['COLUMN_NAME'] for k in keys)}) referencia ({', '.join(k['REFERENCED_COLUMN_NAME'] for k in keys)})."
        for (child, _, parent), keys in grouped.items() if child == parent
    ]
    snapshot = json.loads(counts_path.read_text(encoding='utf-8-sig')) if counts_path else None
    dictionary = render_dictionary(d, entities, rows, len(grouped), views, snapshot)
    diagram_entities = entities
    count_note = []
    if snapshot:
        diagram_entities = []
        for entity in entities:
            count = f"{snapshot['counts'][entity['id']]:,}".replace(',', '\u202f')
            label = f"{entity['label']} · {count} filas"
            diagram_entities.append({
                **entity, 'label': label,
                'width': max(entity['width'], len(label) * 8 + 48),
            })
        count_note = [f"Filas por tabla: {snapshot['origen']} · {snapshot['fecha']}."]
    candidate = {'schema_version': 1, 'diagram_type': 'erd',
                 'meta': {'title': 'Modelo de datos de bd_test', 'locale': 'es',
                          'output': 'Practica03/docs/diagramas/modelo_validado.html',
                          'quality_profile': 'standard', 'views': guided},
                 'layout': {'mode': 'grid', 'gapX': 40, 'gapY': 32},
                 'entities': diagram_entities, 'relationships': relationships,
                 'cards': [{'dot': 'amber', 'title': 'Inventario del esquema',
                            'items': [f"{d['entorno']} · {d['fecha']}", totals,
                                      f'{len(relationships)} relaciones dibujadas y {len(self_refs)} autorreferencias documentadas.',
                                      *count_note, *self_refs]}]}
    if count_note:
        candidate['meta']['subtitle'] = count_note[0]
    diagrams=out/'diagramas';diagrams.mkdir(exist_ok=True)
    (diagrams/'modelo_validado.erd.json').write_text(json.dumps(candidate,ensure_ascii=False,indent=2),encoding='utf-8')
    (out / 'diccionario_datos.html').write_text(
        dictionary, encoding='utf-8'
    )
    (out / 'index.html').write_text(render_atlas(d, entities, rows, grouped, views), encoding='utf-8')
    print('Diccionario exportado:',len(rows),'columnas; Archify:',len(entities),'recuadros,',len(relationships),'relaciones.')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('metadatos',type=Path)
    parser.add_argument('--conteos', type=Path)
    args = parser.parse_args()
    generate(args.metadatos, args.conteos)
