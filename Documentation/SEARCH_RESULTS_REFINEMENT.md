# Search results refinement — 2026-11-11

Discover now prioritizes results during an active search. The browsing introduction is hidden and genre/bookmark/reading filters move into a disclosure. Active non-search filters are indicated by “Filters active”; clearing search restores the full browsing screen. Existing canonical content and filter behavior are preserved.

Chats search now trims whitespace, hides the introductory material during searching and offers a clear action for empty results.

Evidence:
- Search and clear at accessibility XXXL passed; inspected the actual captured screen.
- Normal empty-result search recovery passed.
- Matched “ mira ” search, visible character result, filter disclosure and return to browsing passed.
- Final build: 19 unit tests + matched-search UI test passed.
- Package validator and mocked backend integration passed.
- Latest main-tab accessibility audit remains failing: 37 reports (13 contrast, 21 partially unsupported Dynamic Type, 3 clipping). No audit findings are excluded. The latest audit counts depend on visible content and are not a measure of compliance.
- Audit bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-19-15-+0800.xcresult.
- Matched-search final bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-20-56-+0800.xcresult.

Real publisher identity, public policy/support destinations, secure production gateway and physical-device/assistive-technology QA remain outstanding. This is not submission-ready evidence.
