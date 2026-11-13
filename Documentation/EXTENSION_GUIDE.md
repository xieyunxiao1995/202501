# Adding chapters and characters

## Character model

Each entry in `Tideverse/Resources/Stories/characters.json` has a stable `id`, portrait asset, avatar asset, scene asset, genre, personality, speech cadence, motivations, fiction boundary and story ID. The ID is persisted in chats, memories and moments; never rename an existing published ID casually.

Assets are standard Xcode `.imageset` directories in `Resources/Assets.xcassets`, with `Contents.json` and a JPEG image. The app reads image names rather than file paths. Add new names consistently.

The optional gateway has two generated, trusted allow-lists: `Backend/characters.js` and `Backend/storyCanon.js`. **Run `python3 Backend/sync_content.py` after any character or story change** to keep the app and gateway in sync. The gateway rejects unknown characters or unrecognized choices.

## Authoring new chapters

Each story has `id`, `characterID`, `title`, `tagline`, `premise` and `chapters` array. Every chapter requires:

- `id`: immutable globally unique chapter ID
- `number`: chronological chapter number
- `title`, `setting`, `intro`, `objective`
- `choices`: at least two authored choices with stable `id`, `label`, `outcome`, `memoryHint`

The current first release is a branching **choice-outcome** design, not a dynamic graph. Each chapter advances to the next, and different options produce different outcomes and stored moments. For future complex branching, extend `StoryEngine` with a verified `nextChapterID` graph and migrate the `chapterIndex` model. Do not describe the current system as a full nonlinear narrative graph.

## AI conversations

`ChatViewModel` constructs the last 12 text turns, the current chapter and verified saved chapter-choice IDs, and the approved pinned memories. The gateway sets character persona on the server, not from the client. The model is instructed not to invent a chapter unlock. The app calls `/v1/chat` with URLSession. A later SSE streaming client can preserve this contract and update a streaming bubble without touching authored outcomes.

## Privacy and publishing

Before App Store submission provide verified developer identity, support endpoint, reviewed policy/terms with dates, model data processing clauses, content report handling, abuse cost controls and App Attest or equivalent. Treat current sample Worker as an integration starting point, not a completed anti-abuse product.

## Unit tests and regression checks

Use `python3 Tools/verify_package.py` and `node Backend/self_test.mjs` first, then the included `TideverseTests` Xcode scheme. Expand tests to cover JSON archive validation, identity migration, story choice persistence after container reload, accessibility labels, consent switches, gateway authentication, data deletion and network failures. No automated iOS tests can be executed in this Linux packaging environment.
