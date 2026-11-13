# Tideverse / Midnight Blue edition

## Non-negotiable art and presentation requirements

- iPhone portrait orientation, English text and an always-on midnight-blue theme.
- All **40 characters are original fictional adults aged 29–48**. Keep ages >= 25 for future additions.
- Use fully clothed, non-sexualized cartoon/illustrated character art; no minors, nudity, suggestive poses or explicit content.
- Character illustrations are bundled locally in `Tideverse/Resources/Assets.xcassets` and referenced by names in `characters.json`. Never load portraits from a remote URL.
- The avatar image must depict the same fictional character as the full portrait.
- Story scenes should be original illustrations, consistent with each character's world; separate image sets allow later upgrades.

## Dark design tokens

| Token | Hex | Use |
|---|---|---|
| canvas top | `#050F1F` | Root gradient start |
| canvas bottom | `#071427` | Root gradient end |
| card | `#11243C` | Character, story and chat cards |
| soft | `#162C49` | Composer and choice surfaces |
| border | `#274568` | Optional subtle borders |
| primary | `#429EFF` | Interactive blue accent |
| bright | `#79C8FF` | Overline and captions |
| ink | `#F0F6FF` | Main copy |
| muted | `#B2C6E0` | Supporting copy |

`AppRootView` calls `.preferredColorScheme(.dark)`, and `Info.plist` declares `UIUserInterfaceStyle = Dark` so even initial system-hosted elements are dark. The in-app Settings appearance section displays the fixed `Midnight Blue` style rather than showing an ineffective light-mode toggle.

## Local image resources (shipped with the App target)

Each of the 40 IDs has **three actual imagesets**: `{id}_portrait`, `{id}_avatar` and `{id}_scene`. Dimensions may vary; SwiftUI sizes and crops these assets for each screen.

| Character ID | Adult age | Name | Theme |
|---|---:|---|---|
| mira | 32 | Mira Vale | Mystery archivist |
| jonah | 35 | Jonah Reed | Ocean adventure |
| elara | 38 | Elara Finch | Art conservator |
| rowan | 33 | Rowan Bell | Late-night radio |
| seraphine | 31 | Seraphine Laurent | Observatory fantasy |
| kai | 34 | Kai Mercer | Science fiction |
| luna | 29 | Luna Chen | Cozy neighborhood cafe |
| dimitri | 42 | Dimitri Voss | History and travel |
| nora | 36 | Nora Moss | Botanical conservation |
| theo | 40 | Theo Hart | Clock restoration |
| amara | 37 | Amara Sol | Historical weather evidence |
| felix | 30 | Felix Arden | Community theatre design |

Xcode compiles `Assets.xcassets` through the app target's **PBXResourcesBuildPhase**. `Tests/TideverseTests.swift` checks `UIImage(named:)` for all 24 names and ages >= 25. Portable `Tools/verify_package.py` checks every imageset JSON file and its referenced image.

All 40 portraits and matching avatars were regenerated together in a mature Japanese anime illustration style. Portraits and avatars have genuine alpha transparency; avatars are cropped from the matching portrait source. 32 story environments and the opaque App Store icon were also replaced. Every character remains a fictional adult age 29–48 in modest workwear. Source sheets, exact prompts and previews live in `Artwork/`; `Tools/split_artwork.py` reproduces the cuts without changing story IDs or Xcode asset names.

## Production review

The optional model must not create minors or sexual content. The gateway includes an age and non-explicit policy instruction, but model instructions alone are **not** a comprehensive moderation system. Before broad release, implement and test input/output safety checks, reporting operations and store-policy compliance. Do not promise that generated replies can never violate a policy.

Expansion source sheets and prompts use `Artwork/expansion-prompts.json` and `Tools/split_expansion_artwork.py`. `Tools/preview_artwork.py` creates the full 12-character contact sheet from installed asset files.

## Twenty-character expansion

Twenty new original fictional adults and their complete journeys were added without changing the existing twelve character records or 96 chapters. A later Act II pass extended all twenty expansion journeys to eight chapters. The catalog now contains 32 characters, 256 chapters and 512 choices. All 60 additional art assets use independent imagesets. See `CAST_EXPANSION_20.md` for the new roster, `ACT_II_EXPANSION_20.md` for the second acts, and `Artwork/Expansion20/` for generated source sheets and exact prompts.


## Eight additional adults

Vera, Daria, Lucian, Maeve, Idris, Rhea, Bastien and Anika each have new generated portraits, source-matched avatar thumbnails and independent environments. The Midnight Blue palette and fixed dark appearance remain. See Artwork/Expansion8/Preview.jpg and Documentation/CAST_EXPANSION_8.md.
