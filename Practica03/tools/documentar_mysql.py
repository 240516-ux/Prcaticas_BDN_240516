"""Genera diccionario y fuente Archify desde metadatos MySQL, nunca desde datos personales."""
import argparse
import csv
import html
import json
import re
from collections import Counter
from pathlib import Path


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


def generate(metadata_path):
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
        description = c.get('COLUMN_COMMENT') or ('Referencia a ' + ', '.join(refs[(c['TABLE_NAME'], c['COLUMN_NAME'])])
            if (c['TABLE_NAME'], c['COLUMN_NAME']) in refs else 'Sin comentario de clase confirmado; consultar nombre, tipo y restricciones.')
        rows.append([d['schema'], c['TABLE_NAME'], c['COLUMN_NAME'], c['COLUMN_TYPE'],
                     c['IS_NULLABLE'], c['COLUMN_DEFAULT'], c['COLUMN_KEY'], c['EXTRA'],
                     ', '.join(refs.get((c['TABLE_NAME'], c['COLUMN_NAME']), [])), description])
    header = ['esquema', 'tabla', 'columna', 'tipo', 'admite_null', 'predeterminado', 'clave', 'extra', 'referencias', 'descripcion']
    with (out / 'diccionario_datos.csv').open('w', encoding='utf-8-sig', newline='') as stream:
        writer = csv.writer(stream); writer.writerow(header); writer.writerows(rows)
    esc = lambda value: html.escape('NULL' if value is None else str(value))
    style = '<style>body{font:16px system-ui;margin:2rem;color:#183047}table{border-collapse:collapse;width:100%;margin:1rem 0}th,td{padding:.5rem;border:1px solid #ccd7df;text-align:left;overflow-wrap:anywhere}th{background:#eaf1f7}code{white-space:pre-wrap}input{padding:.6rem;width:min(90%,35rem)}.notice{padding:1rem;background:#fff4ce}details{margin:1rem 0}</style>'
    body = ['<!doctype html><html lang="es"><meta charset="utf-8"><title>Diccionario bd_test</title>', style,
            '<h1>Diccionario de datos: bd_test</h1>',
            '<p class="notice">Origen: ' + esc(d['entorno']) + '. Validado el ' + esc(d['fecha']) +
            '. ' + esc(totals) + '.</p>',
            '<p><a href="index.html">Entrega</a> Â· <a href="diagramas/modelo_validado.html">MERE Archify</a> Â· <a href="diccionario_datos.csv">CSV</a></p>',
            '<input id="f" placeholder="Filtrar por tabla o columna" aria-label="Filtro"><table id="dic"><thead><tr>' + ''.join('<th>'+esc(x)+'</th>' for x in header) + '</tr></thead><tbody>']
    columns_per_table = Counter(c['TABLE_NAME'] for c in columns)
    body.insert(-1, '<details><summary>Columnas por tabla</summary><ul>' + ''.join(
        f'<li>{esc(table)}: {count}</li>' for table, count in sorted(columns_per_table.items())
    ) + '</ul></details>')
    body += ['<tr>' + ''.join('<td>'+esc(x)+'</td>' for x in row) + '</tr>' for row in rows]
    body += ['</tbody></table>']
    for key,title in [('indexes','Indices'),('foreign_keys','Claves foraneas'),('checks','Restricciones CHECK')]:
        entries=d[key]
        body += ['<details open><summary>'+title+'</summary><pre><code>'+esc(json.dumps(entries,ensure_ascii=False,indent=2))+'</code></pre></details>']
    body += ["<script>document.querySelector('#f').addEventListener('input',e=>{for(const r of document.querySelectorAll('#dic tbody tr'))r.hidden=!r.textContent.toLowerCase().includes(e.target.value.toLowerCase())})</script></html>"]
    (out/'diccionario_datos.html').write_text('\n'.join(body),encoding='utf-8')
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
    candidate = {'schema_version': 1, 'diagram_type': 'erd',
                 'meta': {'title': 'Modelo de datos de bd_test', 'locale': 'es',
                          'output': 'Practica03/docs/diagramas/modelo_validado.html',
                          'quality_profile': 'standard', 'views': guided},
                 'layout': {'mode': 'grid', 'gapX': 40, 'gapY': 32},
                 'entities': entities, 'relationships': relationships,
                 'cards': [{'dot': 'amber', 'title': 'Inventario del esquema',
                            'items': [f"{d['entorno']} · {d['fecha']}", totals,
                                      f'{len(relationships)} relaciones dibujadas y {len(self_refs)} autorreferencias documentadas.',
                                      *self_refs]}]}
    diagrams=out/'diagramas';diagrams.mkdir(exist_ok=True)
    (diagrams/'modelo_validado.erd.json').write_text(json.dumps(candidate,ensure_ascii=False,indent=2),encoding='utf-8')
    (out / 'index.html').write_text(render_atlas(d, entities, rows, grouped, views), encoding='utf-8')
    print('Diccionario exportado:',len(rows),'columnas; Archify:',len(entities),'recuadros,',len(relationships),'relaciones.')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('metadatos',type=Path)
    generate(parser.parse_args().metadatos)
