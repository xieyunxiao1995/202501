"""Validate and package rendered marketing PNGs; embed source provenance without changing pixels."""
from pathlib import Path
import struct,zlib,json,hashlib,subprocess
root=Path(__file__).resolve().parents[1]
r=root/'AppStore/Creative-v2'
manifest=json.loads((r/'manifest.json').read_text())
for row in manifest:
 p=r/row['file'];d=p.read_bytes()
 w,h,depth,kind=struct.unpack('>IIBB',d[16:26])
 assert kind==2,(p,'must be opaque RGB')
 if p.parent.name.startswith('iPhone'):assert (w,h)==(1320,2868)
 if b'Provenance\x00' not in d:
  payload=b'Provenance\x00'+json.dumps(row['origin']).encode()
  chunk=struct.pack('>I',len(payload))+b'tEXt'+payload+struct.pack('>I',zlib.crc32(b'tEXt'+payload)&0xffffffff)
  p.write_bytes(d[:33]+chunk+d[33:])
 row['sha256']=hashlib.sha256(p.read_bytes()).hexdigest()
(r/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
subprocess.run(['ditto','-c','-k','--keepParent',str(r),str(root/'AppStore/Tideverse-iPhone-AppStore-Campaign-v2.zip')],check=True)
print('PASS: opaque RGB; iPhone sizes; provenance; zip packaged')
