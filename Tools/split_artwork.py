#!/usr/bin/env python3
"""Split the approved generated sheets into the app's stable asset names.

Usage: python3 Tools/split_artwork.py CHARACTER_SHEET SCENE_SHEET APP_ICON
Requires Pillow. Original generations are retained in Artwork/Source.
"""
from pathlib import Path
import shutil
import sys
from PIL import Image, ImageOps, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "Tideverse/Resources/Assets.xcassets"
IDS = ["mira", "jonah", "elara", "rowan", "seraphine", "kai", "luna", "dimitri"]


def split(character_path, scene_path, icon_path):
    source = ROOT / "Artwork/Source"
    source.mkdir(parents=True, exist_ok=True)
    for original, name in zip((character_path, scene_path, icon_path),
                              ("characters.png", "scenes.png", "app-icon.png")):
        if Path(original).resolve() != (source / name).resolve():
            shutil.copy2(original, source / name)
    characters = Image.open(character_path).convert("RGBA")
    scenes = Image.open(scene_path).convert("RGB")
    if characters.getchannel("A").getextrema()[0] == 255:
        raise ValueError("Character sheet must have genuine transparency")
    for index, character in enumerate(IDS):
        x, y = index % 4, index // 4
        # The approved sheet's visual row divider sits above its geometric
        # midpoint. Explicit cuts exclude the other row's protruding hair.
        top, bottom = ((0, 484) if y == 0 else (490, 1010))
        top = round(top * characters.height / 1024)
        bottom = round(bottom * characters.height / 1024)
        tile = characters.crop((x * characters.width // 4, top,
                                (x + 1) * characters.width // 4, bottom))
        bounds = tile.getchannel("A").point(lambda value: 255 if value > 16 else 0).getbbox()
        if bounds is None:
            raise ValueError(f"Empty character cell: {character}")
        sprite = tile.crop(bounds)
        portrait = Image.new("RGBA", (768, 1024))
        fitted = ImageOps.contain(sprite, (704, 960), Image.Resampling.LANCZOS)
        portrait.alpha_composite(fitted, ((768 - fitted.width) // 2, 1024 - fitted.height))
        portrait.save(ASSETS / f"{character}_portrait.imageset/{character}_portrait.png")
        # The head occupies the upper part of each authored bust. Keep the
        # avatar and portrait derived from the exact same character drawing.
        side = min(sprite.width, round(sprite.height * 0.64))
        left = (sprite.width - side) // 2
        avatar = sprite.crop((left, 0, left + side, side)).resize((512, 512), Image.Resampling.LANCZOS)
        avatar.save(ASSETS / f"{character}_avatar.imageset/{character}_avatar.png")
        x, y = index % 2, index // 2
        scene = scenes.crop((x * scenes.width // 2, y * scenes.height // 4,
                             (x + 1) * scenes.width // 2, (y + 1) * scenes.height // 4))
        scene = ImageOps.fit(scene, (1200, 640), Image.Resampling.LANCZOS)
        scene.save(ASSETS / f"{character}_scene.imageset/{character}_scene.jpg", quality=94)
    icon = Image.open(icon_path).convert("RGB")
    ImageOps.fit(icon, (1024, 1024), Image.Resampling.LANCZOS).save(ASSETS / "AppIcon.appiconset/AppIcon.png")
    preview = Image.new("RGB", (1440, 1120), "#071427")
    draw = ImageDraw.Draw(preview)
    for index, character in enumerate(IDS):
        x, y = (index % 4) * 360, (index // 4) * 560
        portrait = Image.open(ASSETS / f"{character}_portrait.imageset/{character}_portrait.png")
        portrait.thumbnail((270, 360), Image.Resampling.LANCZOS)
        preview.paste(portrait, (x + 45, y + 10), portrait)
        scene = Image.open(ASSETS / f"{character}_scene.imageset/{character}_scene.jpg").resize((336, 179))
        preview.paste(scene, (x + 12, y + 374))
        draw.text((x + 18, y + 354), character.title(), fill="#F0F6FF")
    preview.save(ROOT / "Artwork/Preview.jpg", quality=94)
    print("Replaced 24 character images and the App Store icon.")


if __name__ == "__main__":
    split(*sys.argv[1:])
