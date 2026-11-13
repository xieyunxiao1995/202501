# DeepSeek integration — 2026-11-12

The iOS app connects directly to `https://api.deepseek.com/chat/completions`, using `deepseek-flash`, `thinking.type = enabled`, `reasoning_effort = high`, `stream = false`, and an 8192-token output budget. Requests time out after 120 seconds and retain a 128 KB response limit. Errors distinguish unavailable credit, permission, rate limit, service failures, incomplete generation and invalid responses. Existing cancellation and draft/retry behavior remain active.

At the owner's explicit request, DeepSeekConfiguration.swift assembles a credential from exactly three Base64 fragments. The key is not printed or copied into this document. Encoding and splitting do not provide secret storage; a distributed binary still exposes a recoverable credential. This requested integration is not evidence of safe public credential distribution, spend protection or App Store readiness.

DeepSeekChatAdapter builds the character persona from bundled canonical content, supplies recent user/assistant text, pinned memories, current chapter and validated authored choices. Explicitly selected prepared JPEGs use image_url content parts with data URLs. It sends no files or photos without explicit selection and DeepSeek data consent. Returned reasoning_content is ignored; only the final assistant content is saved. Choice markers are stripped, and only current-chapter IDs can become suggestions. A suggestion still requires user confirmation through StoryEngine.

ConsentService uses deepseek-data-v2. Existing Ark consent or a legacy enabled Boolean is insufficient. The service also checks consent before starting network I/O and again before returning a result; ChatViewModel retains cancellation and deleted-message protections. EULA acceptance remains independent. App privacy/consent/developer/help copy now names DeepSeek and direct processing, and no longer claims that credentials stay off the device or that store:false disables provider storage. API retention depends on actual applicable provider terms and account settings.

The legacy Ark Worker remains under Backend and is not called by this version. Info.plist no longer has an unused gateway origin; Release metadata checking still enforces actual publisher/contact/policy details.

## Verification

- Real provider synthetic vision smoke: HTTP 200, model deepseek-flash, finish_reason stop, correct answer “Green”; 235 input and 22 completion tokens. The fixture was a generated green JPEG, not a personal photo.
- All 30 unit tests passed, including direct request/persona/options, selected JPEG encoding, reasoning suppression, invalid marker stripping, truncated/empty replies, forged canonical context rejection and prior-provider consent rejection before network access.
- Live UI test is opt-in through TEST_RUNNER_TIDEVERSE_LIVE_AI=1 so ordinary test runs do not make paid requests. It covers declining while retaining a draft, explicit provider consent, actual reply persistence and relaunch. The real UI test passed in 51.8 seconds with zero failures, including persistent replies after relaunch. Screenshot: `Documentation/DeepSeek/live-reply.png`.
- The chat/keyboard and offline authored-choice regression passed in 47.2 seconds after declining provider consent; chapter 2 and a saved moment remained reachable.
- No test prints credentials, headers or assembled authorization values. A local check confirmed exactly three Base64 fragments and no plaintext credential in app source/config.

## Official references

- [First API call](https://api-docs.deepseek.com/)
- [Chat Completions parameters](https://api-docs.deepseek.com/api/create-chat-completion)
- [Models and vision support](https://api-docs.deepseek.com/quick_start/pricing/)

Real publisher/support/policy configuration, signed-device QA, content safety and an operational report destination still need completion before public release. This integration does not guarantee App Store approval.

UI refinement follow-up (2026-11-12): all forty characters' first/completed journey requests are covered (80 combinations), preserving each persona's name/voice/boundary/goal. All 32 unit tests and the two-character Mira/Vera live UI run passed. A typed pending-action sheet fixes stale send/retry intent when granting consent from a conversation starter. The reply control now supports stopping generation, while offline chapter choices remain separately available. See UI_REFINEMENT_20261112.md.
