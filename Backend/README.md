# Tideverse optional HTTPS AI gateway

This Cloudflare Worker implements the iOS app's `POST /v1/chat` endpoint and forwards to Volcengine Ark Responses API. `GET /health` exposes basic service readiness. No Ark key is shipped in the iOS project. The Worker uses a canonical server-side character and verified story-choice whitelists, request size limits, and a Cloudflare rate-limit binding. Conversations are never intentionally logged by this source code, and the Ark request sets `store: false`.

## Setup

1. Rotate any Ark credential that was ever pasted into a chat or ticket. Create a **new** key for this deployment.
2. Create a Cloudflare account, install the current Wrangler CLI and authenticate.
3. In this directory, execute `npx wrangler secret put ARK_API_KEY` and paste the newly issued key into the secure CLI prompt. Never check it into git.
4. Bind an approved domain and deploy with `npx wrangler deploy`. The sample `workers_dev = false` requires a custom route or domain.
5. In `Tideverse/Resources/Info.plist`, set `TIDEVERSE_GATEWAY_URL` to your actual `https://` gateway origin, then build the iOS app.
6. Confirm with `curl https://YOUR-GATEWAY/health`. Then validate real text and image round trips on a device.

Example client request **without** confidential credentials:

```bash
curl https://YOUR-GATEWAY/v1/chat \
  -H 'Content-Type: application/json' \
  -d '{"characterID":"mira","chapterIndex":0,"chapterID":"mira_c1","chapterTitle":"A Letter Without a Name","storyChoices":[],"recentMessages":[],"approvedMemories":[],"message":"What did you find?","imageBase64":null}'
```

## Production release blockers (important)

**Do not expose this sample publicly as an unrestricted paid-model relay.** IP-based rate limiting is only one layer and is not a substitute for authenticated clients. Before production: integrate App Attest or equivalent server-verified device authentication, per-install and daily spending quotas, a robust reporting/content-moderation pipeline, WAF and abuse analytics with a documented retention policy, verified publisher and support contact, disclosure of all data processors, and an incident/revocation process. Validate the latest Ark model availability, image input support and region/data processing terms in your real account.

The Worker uses the `instructions` field in Ark Responses API, and reconstructs saved decisions from server-trusted chapter and choice IDs. Update those canon files by running `python3 Backend/sync_content.py` from the project root whenever you add or modify authored stories. Never trust user-provided plot summaries as system prompts.

The Worker deliberately provides non-streaming JSON responses to keep the starter stable. The iOS chat shows a cancellable progress state. Streaming SSE and tool calling can be added later without changing the authored story engine.

The product's **offline** interactive fiction, local save/export/import, and all four tabs do not require a running Worker.

## API contract

`POST /v1/chat` JSON:

- `characterID`: one of 32 bundled character IDs
- `chapterIndex`: zero-based index of the character's current chapter, from `0` to the chapter count
- `chapterID`: ID of the chapter at `chapterIndex`; required while that chapter exists
- `chapterTitle`: current locally saved chapter title, capped at 160 characters
- `storyChoices`: every earlier decision as `{chapterID, choiceID}`; must be an ordered prefix of server-trusted story canon with exactly `chapterIndex` entries
- `recentMessages`: last 12 turns, role `user`/`assistant`, text only
- `approvedMemories`: last 12 explicitly pinned notes, up to 500 UTF-16 units each
- `message`: user text (max 4,000 chars)
- `imageBase64`: optional, metadata-stripped JPEG Base64

Response JSON: `{ "reply": "...", "suggestedChoiceID": "mira_c1_a" }`. The model may append a `[[choice:CHOICE_ID]]` marker to its reply when the user clearly commits to an authored direction; the Worker strips every marker and returns only an ID that belongs to the current chapter, otherwise `null`. This is a nomination, not a story write: the app shows a suggestion card and only records the decision through its canonical story engine when the user confirms. Error response: `{ "error": "..." }`, with relevant HTTP status. The native app does not put Ark credentials in the request.

## Smoke checks

After editing stories, run `python3 Backend/sync_content.py`, `node Backend/self_test.mjs`, and `python3 Tools/verify_package.py`. These verify the request contract and canonical mappings without hitting or billing the provider. Only a manually configured real backend can verify end-to-end Doubao usage.
