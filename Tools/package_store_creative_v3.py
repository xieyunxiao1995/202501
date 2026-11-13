"""Embed non-pixel provenance, validate PNG dimensions and package the iPhone campaign."""
from pathlib import Path
import struct,zlib,json,hashlib,zipfile
root=Path(__file__).resolve().parents[1];r=root/'AppStore/Creative-v3'
sources={
'01-your-next-story':['refined-01-discover.png','mira_portrait','mira_scene'],
'02-meet-the-characters':['refined-01-discover.png','refined-06-profile.png','refined-04-journeys.png','jonah_portrait','elara_portrait','seraphine_scene'],
'03-begin-a-conversation':['refined-07-conversation.png; enlarged crop x175 y804 w975 h335','vera_portrait','vera_scene'],
'04-your-story-to-keep':['refined-04-journeys.png; enlarged crop x65 y1765 w1080 h440','luna_scene'],
'Preview':['four finished v3 campaign posters']}
manifest=[]
for p in [*sorted(r.glob('iPhone-*/*.png')),r/'Preview.png']:
 d=p.read_bytes();w,h,depth,kind=struct.unpack('>IIBB',d[16:26]);assert kind==2,(p,'must be opaque RGB')
 if p.parent.name.startswith('iPhone'):assert (w,h)==(1320,2868)
 origin={'method':'native AppKit composition, existing app art and actual screenshots; no synthesized UI','sources':sources[p.stem],'renderer':'Tools/render_store_creative_v3.swift','styleReferences':'user-provided Tavo and Swerve iPhone screenshots; composition inspiration only'}
 if b'Provenance\x00' not in d:
  payload=b'Provenance\x00'+json.dumps(origin).encode();chunk=struct.pack('>I',len(payload))+b'tEXt'+payload+struct.pack('>I',zlib.crc32(b'tEXt'+payload)&0xffffffff);p.write_bytes(d[:33]+chunk+d[33:])
 manifest.append({'file':str(p.relative_to(r)),'width':w,'height':h,'alpha':False,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'origin':origin})
(r/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
with zipfile.ZipFile(root/'AppStore/Tideverse-iPhone-AppStore-References-v3.zip','w',zipfile.ZIP_DEFLATED) as archive:
 for f in sorted(r.rglob('*')):
  if f.is_file() and not f.name.startswith('._') and f.name != '.DS_Store':archive.write(f,f.relative_to(r.parent))
print('PASS: four 1320 x 2868 opaque RGB posters; provenance embedded; zip created')
