# Reading continuity — 2026-11-11

- Chapter scrolling now respects the system Reduce Motion environment.
- Scroll to the next chapter only after dismissing the saved-moment sheet.
- Final-choice dismissal scrolls to a stable ending anchor rather than leaving the reader at the prior choice.
- Added Continue reading / View ending toolbar navigation.
- Chapter and ending titles are heading elements and receive requested accessibility focus.

Evidence: simulator eight-chapter UI test passed, including all saved-moment dismissals, directly visible ending, and ending shortcut. Inspected the captured ending screenshot. Package and mocked gateway checks passed. Actual VoiceOver focus and Reduce Motion device behavior remain unverified.
