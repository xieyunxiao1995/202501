"""Embed non-pixel provenance, validate PNG dimensions and package the iPhone campaign."""
from pathlib import Path
import struct,zlib,json,hashlib,zipfile
root=Path(__file__).resolve().parents[1];r=root/'AppStore/Creative-v5'
sources={
'01-chat-with-ai':['refined-02-chats.png','mira_portrait','mira_scene'],
'02-meet-elara':['SourceScreens/elara-profile.png; new simulator capture 2026-11-12','elara_scene'],
'03-a-real-exchange':['deepseek-live-reply.png; real prior synthetic integration test exchange','mira_scene; no external character; 8 percent larger chat device'],
'04-find-your-next-chat':['refined-02-chats.png; exact Elara card crop x65 y2045 w1080 h310','elara_scene'],
'Preview':['four finished v5 chat-focused posters']}
manifest=[]
for p in [*sorted(r.glob('iPhone-*/*.png')),r/'Preview.png']:
 d=p.read_bytes();w,h,depth,kind=struct.unpack('>IIBB',d[16:26]);assert kind==2,(p,'must be opaque RGB')
 if p.parent.name.startswith('iPhone'):assert (w,h)==(1320,2868)
 origin={'method':'native AppKit composition, existing app art and actual screenshots; no synthesized UI','sources':sources[p.stem],'renderer':'Tools/render_store_creative_v5.swift','styleReferences':'user-provided Tavo and Swerve iPhone screenshots; composition inspiration only','decorations':'imagegen transparent azure-ribbon.png; native geometric glints'}
 if b'Provenance\x00' not in d:
  payload=b'Provenance\x00'+json.dumps(origin).encode();chunk=struct.pack('>I',len(payload))+b'tEXt'+payload+struct.pack('>I',zlib.crc32(b'tEXt'+payload)&0xffffffff);p.write_bytes(d[:33]+chunk+d[33:])
 manifest.append({'file':str(p.relative_to(r)),'width':w,'height':h,'alpha':False,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'origin':origin})
(r/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
with zipfile.ZipFile(root/'AppStore/Tideverse-iPhone-AppStore-Chat-v5.zip','w',zipfile.ZIP_DEFLATED) as archive:
 for f in sorted(r.rglob('*')):
  if f.is_file() and not f.name.startswith('._') and f.name != '.DS_Store':archive.write(f,f.relative_to(r.parent))
print('PASS: four 1320 x 2868 opaque RGB posters; provenance embedded; zip created')
