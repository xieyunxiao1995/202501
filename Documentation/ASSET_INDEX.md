# Asset index — Midnight Blue / adult cartoon edition

This Xcode project **bundles** the actual illustration files. The complete `Assets.xcassets` catalog is included in the app target resource build phase and is not merely a documentation attachment.

| Character | Age | Portrait | Avatar | Scene |
|---|---:|---|---|---|
| Mira Vale | 32 | `mira_portrait.png` | `mira_avatar.png` | `mira_scene.jpg` |
| Jonah Reed | 35 | `jonah_portrait.png` | `jonah_avatar.png` | `jonah_scene.jpg` |
| Elara Finch | 38 | `elara_portrait.png` | `elara_avatar.png` | `elara_scene.jpg` |
| Rowan Bell | 33 | `rowan_portrait.png` | `rowan_avatar.png` | `rowan_scene.jpg` |
| Seraphine Laurent | 31 | `seraphine_portrait.png` | `seraphine_avatar.png` | `seraphine_scene.jpg` |
| Kai Mercer | 34 | `kai_portrait.png` | `kai_avatar.png` | `kai_scene.jpg` |
| Luna Chen | 29 | `luna_portrait.png` | `luna_avatar.png` | `luna_scene.jpg` |
| Dimitri Voss | 42 | `dimitri_portrait.png` | `dimitri_avatar.png` | `dimitri_scene.jpg` |
| Nora Moss | 36 | `nora_portrait.png` | `nora_avatar.png` | `nora_scene.jpg` |
| Theo Hart | 40 | `theo_portrait.png` | `theo_avatar.png` | `theo_scene.jpg` |
| Amara Sol | 37 | `amara_portrait.png` | `amara_avatar.png` | `amara_scene.jpg` |
| Felix Arden | 30 | `felix_portrait.png` | `felix_avatar.png` | `felix_scene.jpg` |
| Sylvie Quill | 29 | `sylvie_portrait.png` | `sylvie_avatar.png` | `sylvie_scene.jpg` |
| Mateo Rios | 36 | `mateo_portrait.png` | `mateo_avatar.png` | `mateo_scene.jpg` |
| Ines Aster | 41 | `ines_portrait.png` | `ines_avatar.png` | `ines_scene.jpg` |
| Silas Morrow | 44 | `silas_portrait.png` | `silas_avatar.png` | `silas_scene.jpg` |
| Tessa Briar | 33 | `tessa_portrait.png` | `tessa_avatar.png` | `tessa_scene.jpg` |
| Owen Lark | 35 | `owen_portrait.png` | `owen_avatar.png` | `owen_scene.jpg` |
| Leonie Wren | 38 | `leonie_portrait.png` | `leonie_avatar.png` | `leonie_scene.jpg` |
| Zane Hollis | 40 | `zane_portrait.png` | `zane_avatar.png` | `zane_scene.jpg` |
| Freya Linden | 34 | `freya_portrait.png` | `freya_avatar.png` | `freya_scene.jpg` |
| Malik Sable | 37 | `malik_portrait.png` | `malik_avatar.png` | `malik_scene.jpg` |
| Celia Ridge | 45 | `celia_portrait.png` | `celia_avatar.png` | `celia_scene.jpg` |
| Nico Venn | 30 | `nico_portrait.png` | `nico_avatar.png` | `nico_scene.jpg` |
| Ada Frost | 46 | `ada_portrait.png` | `ada_avatar.png` | `ada_scene.jpg` |
| Hugo Perrin | 43 | `hugo_portrait.png` | `hugo_avatar.png` | `hugo_scene.jpg` |
| Sana Ilyas | 32 | `sana_portrait.png` | `sana_avatar.png` | `sana_scene.jpg` |
| Vincent Ash | 48 | `vincent_portrait.png` | `vincent_avatar.png` | `vincent_scene.jpg` |
| Petra Kestrel | 36 | `petra_portrait.png` | `petra_avatar.png` | `petra_scene.jpg` |
| Ellis Brook | 39 | `ellis_portrait.png` | `ellis_avatar.png` | `ellis_scene.jpg` |
| Yara Keswick | 31 | `yara_portrait.png` | `yara_avatar.png` | `yara_scene.jpg` |
| Noel Quinn | 42 | `noel_portrait.png` | `noel_avatar.png` | `noel_scene.jpg` |

All filenames are nested within correspondingly named `.imageset` directories. Portraits are 768x1024 transparent PNG; avatars are 512x512 transparent PNG; scenes are 1200x640 opaque JPEG. All 96 images were replaced with coordinated adult anime character art and illustrated environments. Each is referenced from `Tideverse/Resources/Stories/characters.json` via `portraitAsset`, `avatarAsset` and `sceneAsset`, and used by the native SwiftUI views.

`AppIcon.appiconset/AppIcon.png` is the new 1024x1024 opaque RGB storybook-and-wave icon. `Documentation/CHARACTER_PREVIEW.jpg` is an extra review contact sheet and is not used as an in-app asset.

Source sheets, exact imagegen prompts, previews and the repeatable slicing command are documented in `Artwork/README.md`.

Age is a fictional character attribute in the story JSON, not a claim about a real person. There are no underage personas, nudity or intentionally sexualized portraits.
