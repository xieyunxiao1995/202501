# FlowCanvas - Your Focus & Expression Companion

A Flutter app that combines multi-stage interval timers with scrolling marquee displays for focus sessions and public expression.

## Features

### 🎯 Multi-Stage Timer
- Create complex workflows with multiple time stages
- Support for multiple cycles (e.g., HIIT training, study sessions)
- Live progress tracking with visual indicators
- Fullscreen immersive timer mode
- Quick start templates (Pomodoro, Workout, Reading, Meditation)
- Daily statistics tracking

### 📺 Scrolling Marquee
- Customizable text display with horizontal scrolling
- 6 vibrant color options
- Adjustable scrolling speed
- Fullscreen display mode
- Save and reuse marquee templates
- Perfect for concerts, airport pickups, celebrations

### 🔗 Scene Combos
- Combine timers and marquees into automated sequences
- Create custom scenarios (e.g., wait timer → welcome message)
- Featured combo templates
- One-tap execution

### 👤 Profile & Settings
- Achievement tracking
- Content management (templates, combos)
- Customizable settings (sound, vibration, screen timeout)
- Usage statistics

## Design Philosophy

- **Elegant aesthetics** with gradient backgrounds and glass-morphism effects
- **Immersive experience** with fullscreen modes
- **Intuitive navigation** with bottom tab bar
- **Modern UI** following iOS design principles
- **Dark theme** optimized for low-light environments

## Technical Stack

- Flutter SDK 3.9.2+
- State management: setState (as per requirements)
- Data persistence: shared_preferences
- Portrait orientation only
- No external assets required

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── workflow.dart
│   ├── marquee.dart
│   └── combo.dart
├── screens/                     # Main screens
│   ├── home_screen.dart        # Main navigation
│   ├── timer_tab.dart          # Timer functionality
│   ├── marquee_tab.dart        # Marquee functionality
│   ├── combo_tab.dart          # Combo management
│   ├── profile_tab.dart        # Settings & profile
│   ├── fullscreen_timer.dart   # Fullscreen timer view
│   └── fullscreen_marquee.dart # Fullscreen marquee view
└── widgets/                     # Reusable widgets
    └── glass_card.dart         # Glass-morphism card
```

## Color Palette

- Primary: `#6366F1` (Indigo)
- Secondary: `#F97316` (Orange)
- Accent: `#10B981` (Green)
- Background: `#0F172A` (Dark Blue)
- Card: `#1E293B` (Slate)

## Usage Examples

### Creating a Workout Timer
1. Navigate to Timer tab
2. Tap "Create New Workflow"
3. Add stages: Warm-up (5min) → Sprint (20min) → Cool-down (5min)
4. Set cycles: 3
5. Tap "Start" to begin

### Creating a Welcome Marquee
1. Navigate to Marquee tab
2. Enter text: "Welcome Home!"
3. Select color (e.g., Neon Green)
4. Adjust speed slider
5. Tap "Start Scrolling" or "Fullscreen"

### Creating a Combo
1. Navigate to Combo tab
2. Tap "Create New Combo"
3. Select a timer workflow
4. Select a marquee template
5. Save and run the combo

## License

This project is created for personal use.
