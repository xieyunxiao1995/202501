# Backup restore refinement — 2026-11-11

The file importer now validates an archive before asking the user to merge it. The confirmation reports archive date and counts of messages, memories, moments and journeys, and explicitly explains that newer archived progress can replace current chapter choices.

Validation and import share one normalization path. Saved moments now resolve the authored choice using the archive's validated choice-history ID, rather than trusting a conflicting prose label. Malformed JSON becomes an understandable unsupported-archive error. Successful imports report added records and updated journey counts separately.

Evidence:
- 19 unit tests passed, including preview without local mutation, malformed archive rejection, conflicting-label normalization and full 32-journey backup round trip.
- Package verification and mocked gateway integration passed.
- Native file-provider picker and revised confirmation have compiled but have not been interactively verified in this pass.
- No publisher metadata, live service or App Store approval is claimed.
