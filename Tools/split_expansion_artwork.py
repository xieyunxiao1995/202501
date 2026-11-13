#!/usr/bin/env python3
"""Rebuild four adult character assets from the approved expansion sheets."""
from pathlib import Path
from PIL import Image, ImageOps
import json
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / 'Tideverse/Resources/Assets.xcassets'
IDS = ['nora', 'theo', 'amara', 'felix']

def split(character_path, scene_path):
    source = ROOT / 'Artwork/Source'
    source.mkdir(parents=True, exist_ok=True)
    for path, name in [(character_path, 'expansion-characters.png'), (scene_path, 'expansion-scenes.png')]:
        if Path(path).resolve() != (source/name).resolve():
            shutil.copy2(path, source/name)
    people = Image.open(character_path).convert('RGBA')
    scenes = Image.open(scene_path).convert('RGB')
    assert people.getchannel('A').getextrema()[0] == 0, 'Transparent source required'
    for i, cid in enumerate(IDS):
        x, y = i % 2, i // 2
        top, bottom = (0, 608) if y == 0 else (614, 1230)
        tile = people.crop((x*people.width//2, round(top*people.height/1254), (x+1)*people.width//2, round(bottom*people.height/1254)))
        bounds = tile.getchannel('A').point(lambda a: 255 if a > 16 else 0).getbbox()
        if bounds is None: raise ValueError(cid)
        sprite = tile.crop(bounds)
        portrait = Image.new('RGBA', (768,1024))
        fitted = ImageOps.contain(sprite,(704,960),Image.Resampling.LANCZOS)
        portrait.alpha_composite(fitted,((768-fitted.width)//2,1024-fitted.height))
        side = min(sprite.width,round(sprite.height*.64))
        left = (sprite.width-side)//2
        avatar = sprite.crop((left,0,left+side,side)).resize((512,512),Image.Resampling.LANCZOS)
        scene = scenes.crop((x*scenes.width//2,y*scenes.height//2,(x+1)*scenes.width//2,(y+1)*scenes.height//2))
        scene = ImageOps.fit(scene,(1200,640),Image.Resampling.LANCZOS)
        for kind, image, ext in [('portrait',portrait,'png'),('avatar',avatar,'png'),('scene',scene,'jpg')]:
            folder = ASSETS/f'{cid}_{kind}.imageset'
            folder.mkdir(exist_ok=True)
            filename = f'{cid}_{kind}.{ext}'
            image.save(folder/filename, **({'quality':94} if ext=='jpg' else {}))
            (folder/'Contents.json').write_text(json.dumps({'images':[{'filename':filename,'idiom':'universal'}],'info':{'author':'xcode','version':1}},indent=2)+'\n')
    preview = Image.new('RGB',(1200,600),'#11243C')
    for i,cid in enumerate(IDS):
        im = Image.open(ASSETS/f'{cid}_portrait.imageset/{cid}_portrait.png')
        im.thumbnail((280,380),Image.Resampling.LANCZOS)
        preview.paste(im,(i*300+(300-im.width)//2,0),im)
        scene=Image.open(ASSETS/f'{cid}_scene.imageset/{cid}_scene.jpg').resize((290,155))
        preview.paste(scene,(i*300+5,400))
    preview.save(ROOT/'Artwork/ExpansionPreview.jpg',quality=94)
    print('Added 12 expansion images with stable asset names.')

if __name__ == '__main__':
    split(*sys.argv[1:])
