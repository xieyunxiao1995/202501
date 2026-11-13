#!/usr/bin/env python3
"""Render a contact sheet from the exact image files referenced by the app."""
from pathlib import Path
import json
import math
import argparse
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[1]
characters=json.loads((root/'Tideverse/Resources/Stories/characters.json').read_text())
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--ids', nargs='+')
parser.add_argument('--output', type=Path)
args=parser.parse_args()
if args.ids:
    characters=[c for c in characters if c['id'] in args.ids]
assert characters, 'No matching characters'
assets=root/'Tideverse/Resources/Assets.xcassets'
preview=Image.new('RGB',(1440,math.ceil(len(characters)/4)*560),'#071427')
draw=ImageDraw.Draw(preview)
for index,c in enumerate(characters):
    x,y=index%4*360,index//4*560
    portrait=Image.open(assets/f'{c["portraitAsset"]}.imageset/{c["portraitAsset"]}.png')
    portrait.thumbnail((270,360),Image.Resampling.LANCZOS)
    preview.paste(portrait,(x+(360-portrait.width)//2,y+10),portrait)
    scene=Image.open(assets/f'{c["sceneAsset"]}.imageset/{c["sceneAsset"]}.jpg').resize((336,179))
    preview.paste(scene,(x+12,y+374))
    draw.text((x+18,y+354),f'{c["name"]} / {c["age"]}',fill='#F0F6FF')
for path in ([args.output] if args.output else [root/'Artwork/FullPreview.jpg',root/'Documentation/CHARACTER_PREVIEW.jpg']):
    preview.save(path,quality=94)
print(f'Rendered {len(characters)} characters with matching scenes.')
