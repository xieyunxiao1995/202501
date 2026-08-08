# Creative Mode Closure Design

## Goal

Complete the Creative Mode loop from mode selection through local progress, result feedback, statistics, and achievements without introducing a second Solitaire engine, networking, coins, purchases, push, social features, or vibration.

## Confirmed product decisions

- Treasure Hunt has five treasures per deal.
- Time Trial offers 30 seconds, 1 minute, and Unlimited. The first two are countdown challenges; Unlimited is a normal elapsed timer with no time-out.
- One-Draw Sprint keeps the existing one-card draw and zero stock-recycle rule.
- Joker Rescue is hidden from the Creative page but remains in the data enum for a future release.
- Shadow Solitaire and Chain Deck remain visible as `Future Mode` cards and are not playable in this iteration.

## Architecture

`CreativeProgress` is the single source of truth for Creative play counts, wins, best times, treasure totals, best stars, and last played mode. `GameStorage` owns its SharedPreferences key, while Creative screens load immutable snapshots and refresh after navigation. The Solitaire board emits start/win events to the storage boundary and receives only the selected mode and optional Time Trial limit.

Creative-specific result data is passed to the existing `WinSheet`, which remains the shared result surface for classic and Creative games. Statistics and Achievement screens read both existing `PlayerProgress` and `CreativeProgress`; no new state-management dependency is required because the app already uses local StatefulWidget loading with SharedPreferences.

## Rules

- Treasure targets are deterministic cards selected from the initial hidden stock; five target keys are tracked without changing `PlayingCard`.
- Time Trial countdowns show remaining time, stop accepting moves at zero, and present a retry/back dialog. Unlimited mode keeps the existing pace messages.
- Creative games never load or overwrite the classic active-game save and do not increment classic statistics.
- Starting a Creative deal increments `played`; winning records `wins`, best time, best stars, and Treasure Hunt progress.

## Out of scope

Shadow Solitaire's memory reveal, Chain Deck locks, Joker card rules, Creative daily challenges, cloud sync, leaderboards, and monetization remain out of scope.
