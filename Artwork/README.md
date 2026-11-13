# Tideverse artwork

The asset catalog uses twelve original adult characters, ages 29–42, in a
consistent cozy cartoon style. All characters wear modest, fully covering
workwear. The character source sheet has genuine transparency. Scenes are
opaque environment illustrations; the App Store icon is opaque RGB.

Generated with the built-in imagegen tool. Exact prompts are in `prompts.json`.
Source sheets are kept in `Source/` for repeatable slicing. They are not app
resources. `Preview.jpg` shows the installed character and scene resources.

Rebuild the assets with:

```sh
python3 Tools/split_artwork.py Artwork/Source/characters.png Artwork/Source/scenes.png Artwork/Source/app-icon.png
```

The splitter keeps all existing Xcode imageset names and story identifiers.

Four added characters use `expansion-prompts.json`, `Source/expansion-characters.png`, `Source/expansion-scenes.png` and `Tools/split_expansion_artwork.py`. Run `python3 Tools/preview_artwork.py` for the current complete `FullPreview.jpg`. All generations used the built-in imagegen tool.
