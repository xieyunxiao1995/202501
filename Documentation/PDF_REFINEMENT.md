# Story Moment export — 2026-11-11

Fixed one-page PDF rendering that could truncate long imported moment text. Core Text now flows title, date, choice and recap over as many pages as needed, with a page-number footer clear of the text area. Normal bundled moments stay on one page.

Added a Done button to the PDF preview and a general Story Moment error title so deletion errors are not mislabeled as PDF errors. Help now uses the current Begin the journey wording and offers empty-search recovery.

Verification: 18 unit tests passed, including a 500-sentence recap whose final sentence survives PDF extraction and a bundled story outcome on one page. Package and mocked gateway checks passed. PDF page image inspection recorded separately in test attachments. Physical printer and device preview remain untested.
