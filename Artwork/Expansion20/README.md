# Twenty-character artwork expansion

Generated using the built-in imagegen tool. The five character sheets contain four original fictional adults each, with genuine transparency. Five scene sheets provide corresponding environments. Every character wears modest workwear and is age 29–48. No existing character images were replaced.

- `plan.json`: grid order, identities and environment descriptions.
- `prompts.json`: exact final prompt set.
- `Source/`: ten original generated sheets, retained for repeatable extraction.
- `Preview.jpg`: the twenty new installed character/scene assets.

Run `python3 Tools/split_cast20_artwork.py` to reproduce the 60 imagesets. Run `python3 Tools/preview_artwork.py` to refresh the complete catalog preview. Cropping preserves alpha, removes panel divider pixels and derives each avatar from the same character drawing as its portrait.
