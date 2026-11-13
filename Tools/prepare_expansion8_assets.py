#!/usr/bin/env python3
"""Package the eight approved character renders into catalog-sized assets.

Only size fitting and avatar thumbnail extraction are performed; source art is preserved.
"""
from pathlib import Path
from PIL import Image, ImageOps
import json
ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'Artwork/Expansion8/Source'
ASSETS=ROOT/'Tideverse/Resources/Assets.xcassets'
IDS=['vera','daria','lucian','maeve','idris','rhea','bastien','anika']
for cid in IDS:
    original=Image.open(SOURCE/f'{cid}-portrait.png').convert('RGBA')
    assert original.getchannel('A').getextrema()[0]==0, f'{cid} needs real source alpha'
    bounds=original.getchannel('A').point(lambda a: 255 if a>16 else 0).getbbox()
    assert bounds,cid
    sprite=original.crop(bounds)
    fitted=ImageOps.contain(sprite,(704,992),Image.Resampling.LANCZOS)
    portrait=Image.new('RGBA',(768,1024))
    portrait.alpha_composite(fitted,((768-fitted.width)//2,1024-fitted.height))
    side=min(sprite.width,round(sprite.height*.54))
    avatar=sprite.crop(((sprite.width-side)//2,0,(sprite.width+side)//2,side)).resize((512,512),Image.Resampling.LANCZOS)
    scene=ImageOps.fit(Image.open(SOURCE/f'{cid}-scene.png').convert('RGB'),(1200,640),Image.Resampling.LANCZOS)
    for kind,im,ext in [('portrait',portrait,'png'),('avatar',avatar,'png'),('scene',scene,'jpg')]:
        name=f'{cid}_{kind}';folder=ASSETS/f'{name}.imageset';folder.mkdir(exist_ok=True)
        filename=f'{name}.{ext}'
        im.save(folder/filename,**({'quality':94} if ext=='jpg' else {}))
        (folder/'Contents.json').write_text(json.dumps({'images':[{'filename':filename,'idiom':'universal'}],'info':{'author':'xcode','version':1}},indent=2)+'\n')
    print('Packaged',cid)
