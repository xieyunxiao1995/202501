#!/usr/bin/env python3
"""Split the approved five adult-character and five scene sheets into 60 assets."""
from pathlib import Path
from PIL import Image, ImageOps, ImageDraw
import json

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'Artwork/Expansion20'
ASSETS=ROOT/'Tideverse/Resources/Assets.xcassets'
plan=json.loads((SOURCE/'plan.json').read_text())
created=[]
for group in plan:
    people=Image.open(SOURCE/f'Source/{group["key"]}-characters.png').convert('RGBA')
    scenes=Image.open(SOURCE/f'Source/{group["key"]}-scenes.png').convert('RGB')
    assert people.getchannel('A').getextrema()[0]==0,'A real transparent sheet is required'
    assert people.width==people.height and scenes.width==scenes.height,'Expected square 2x2 sheets'
    for i,cid in enumerate(group['ids']):
        x,y=i%2,i//2
        column=people.crop((x*people.width//2,0,(x+1)*people.width//2,people.height))
        mask=column.getchannel('A').point(lambda a:255 if a>32 else 0)
        candidates=range(round(people.height*.46),round(people.height*.54))
        divider=min(candidates,key=lambda row:(mask.crop((0,row,mask.width,row+1)).histogram()[255],abs(row-people.height/2)))
        top,bottom=(0,divider-2) if y==0 else (divider+2,people.height)
        tile=column.crop((0,top,column.width,bottom))
        bounds=tile.getchannel('A').point(lambda a:255 if a>16 else 0).getbbox()
        assert bounds is not None,cid
        sprite=tile.crop(bounds)
        fitted=ImageOps.contain(sprite,(704,960),Image.Resampling.LANCZOS)
        portrait=Image.new('RGBA',(768,1024))
        portrait.alpha_composite(fitted,((768-fitted.width)//2,1024-fitted.height))
        side=min(sprite.width,round(sprite.height*.64));left=(sprite.width-side)//2
        avatar=sprite.crop((left,0,left+side,side)).resize((512,512),Image.Resampling.LANCZOS)
        # Remove any generated panel-divider pixels before fitting the scene.
        inset=max(3,round(scenes.width*.003))
        scene=scenes.crop((x*scenes.width//2+inset,y*scenes.height//2+inset,(x+1)*scenes.width//2-inset,(y+1)*scenes.height//2-inset))
        scene=ImageOps.fit(scene,(1200,640),Image.Resampling.LANCZOS)
        for kind,im,ext in [('portrait',portrait,'png'),('avatar',avatar,'png'),('scene',scene,'jpg')]:
            name=f'{cid}_{kind}';folder=ASSETS/f'{name}.imageset';folder.mkdir(exist_ok=True)
            filename=f'{name}.{ext}'
            im.save(folder/filename,**({'quality':94} if ext=='jpg' else {}))
            (folder/'Contents.json').write_text(json.dumps({'images':[{'filename':filename,'idiom':'universal'}],'info':{'author':'xcode','version':1}},indent=2)+'\n')
            created.append(name)
    print(f'Group {group["key"]}: four matched portrait/avatar/scene sets saved.')
preview=Image.new('RGB',(1440,2800),'#071427');draw=ImageDraw.Draw(preview)
ids=[cid for group in plan for cid in group['ids']]
for i,cid in enumerate(ids):
    x,y=(i%4)*360,(i//4)*560
    im=Image.open(ASSETS/f'{cid}_portrait.imageset/{cid}_portrait.png');im.thumbnail((270,350),Image.Resampling.LANCZOS)
    preview.paste(im,(x+(360-im.width)//2,y+10),im)
    draw.text((x+16,y+354),cid.title(),fill='#F0F6FF')
    im=Image.open(ASSETS/f'{cid}_scene.imageset/{cid}_scene.jpg').resize((336,179))
    preview.paste(im,(x+12,y+374))
preview.save(SOURCE/'Preview.jpg',quality=94)
assert len(created)==60 and len(set(created))==60
print('Added 60 distinct assets for 20 original adult characters.')
