# CP嗒啧 - Kintsugi Artisan Companion

---

## App Identity

### App Name
**CP嗒啧**

**Etymology (5 Word Roots):**
- **Or** (from Latin "aurum" - gold, the precious material in Kintsugi)
- **Cla** (from "clay" - ceramic material being repaired)
- **Vita** (Latin - life, restoration of broken object's purpose)
- **Men** (from "mending" - the act of repair)
- **Syn** (from Greek "synthesis" - joining together)

**Name Characteristics:**
- Length: 13 characters (under 15 limit)
- Contains no complete English dictionary words
- Sounds premium, unique, and memorable
- Elegantly captures the essence of golden repair synthesis

---

## Concept Overview

### Hyper-Niche Domain
**Kintsugi** - The 400-year-old Japanese art of repairing broken pottery with lacquer dusted with powdered gold, silver, or platinum. This philosophy embraces imperfection and treats breakage as part of an object's history rather than something to disguise.

### Target Audience
- Ceramic artists and pottery hobbyists exploring Kintsugi techniques
- Art therapy practitioners using Kintsugi for healing narratives
- Wabi-sabi philosophy enthusiasts
- Museum conservators learning Japanese restoration methods
- Meditation practitioners who find meaning in repair rituals

### Core Value Proposition
A visual companion that transforms broken ceramic pieces into documented artistic journeys. Users photograph their repairs at each stage, receive AI-guided technique suggestions, and build a gallery of their golden seams - turning every crack into a story.

### Killer Feature (The Hook)
**"Crack Narrative Generator"** - AI analyzes photographed broken pieces and generates poetic narratives for each crack line, suggesting philosophical meanings and aesthetic repair approaches. Each repair becomes a documented story, not just a fix.

---

## Strict Multi-File Architecture Definition

### Architecture Iron Law
**FORBIDDEN**: Writing all code in `main.dart`. The entry point must ONLY contain app initialization and routing.

### Directory Structure (Strict)

```
lib/
├── main.dart                      # Entry point ONLY - runApp() + initialization
├── app.dart                       # MaterialApp configuration
│
├── config/
│   ├── app_config.dart            # API keys, constants, environment config
│   └── routes.dart                # Named routes and navigation configuration
│
├── models/
│   ├── repair_project.dart       # RepairProject data model
│   ├── chat_message.dart         # ChatMessage data model
│   └── user_preferences.dart     # UserPreferences data model
│
├── services/
│   ├── storage_service.dart      # SharedPreferences wrapper
│   ├── ai_service.dart           # DeepSeek API client
│   ├── image_service.dart        # Camera/Gallery image handling
│   └── project_service.dart      # CRUD operations for RepairProject
│
├── theme/
│   ├── app_colors.dart           # Color palette constants
│   ├── app_text_styles.dart      # Typography definitions
│   ├── app_decorations.dart      # Reusable decoration styles
│   └── painters/                 # Custom painters for UI elements
│       ├── gold_seam_painter.dart       # Paints gold crack lines
│       ├── ceramic_gradient_painter.dart # Ceramic surface gradients
│       ├── progress_ring_painter.dart    # Circular progress indicator
│       └── ink_splash_painter.dart      # Ink splash animation effect
│
├── screens/
│   ├── splash_screen.dart        # Screen 1
│   │
│   ├── onboarding/               # Screens 2-5
│   │   ├── onboarding_screen.dart      # Container with page indicators
│   │   ├── onboarding_step1.dart       # Welcome to Kintsugi
│   │   ├── onboarding_step2.dart       # Photo guide
│   │   ├── onboarding_step3.dart       # AI assistant intro
│   │   └── onboarding_step4.dart       # Journey begins
│   │
│   ├── eula_screen.dart          # Screen 6 - EULA with AI disclosure
│   │
│   ├── main/                     # Screens 7-10 (Bottom Navigation)
│   │   ├── main_screen.dart            # Bottom nav container
│   │   ├── gallery_screen.dart        # Home - project cards
│   │   ├── new_repair_screen.dart     # Create new project
│   │   ├── ai_chat_screen.dart        # AI conversation
│   │   └── settings_screen.dart       # Settings menu
│   │
│   ├── detail/                   # Screens 11-14
│   │   ├── repair_detail_screen.dart    # Full project view
│   │   ├── photo_fullscreen.dart        # Enlarged image
│   │   ├── technique_analysis_screen.dart # AI repair chart
│   │   └── gallery_empty_state.dart     # Empty state placeholder
│   │
│   ├── settings/                 # Screens 15-19 (Independent)
│   │   ├── about_screen.dart           # About CP嗒啧
│   │   ├── user_agreement_screen.dart  # Full EULA
│   │   ├── privacy_policy_screen.dart   # Data handling
│   │   ├── help_tutorial_screen.dart    # Usage guide
│   │   └── feedback_screen.dart        # Feedback form
│   │
│   └── statistics_screen.dart    # Screen 20 - Analytics
│
├── widgets/
│   ├── common/                   # Reusable UI components
│   │   ├── ceramic_card.dart           # Elevated project card
│   │   ├── gold_seam_badge.dart        # Status indicator
│   │   ├── kintsugi_divider.dart       # Gold gradient divider
│   │   ├── ink_button.dart             # Custom gradient button
│   │   ├── chat_bubble.dart            # Message bubble
│   │   ├── progress_ring.dart          # Circular progress
│   │   ├── photo_capture_widget.dart    # Camera interface
│   │   ├── aesthetic_selector.dart     # Style picker cards
│   │   └── empty_state_widget.dart     # Placeholder display
│   │
│   └── custom_navigation/        # Non-standard navigation components
│       ├── ceramic_bottom_nav.dart      # Custom bottom navigation
│       ├── organic_tab_indicator.dart   # Flowing tab indicator
│       ├── swipe_action_widget.dart     # Swipe-to-reveal actions
│       └── hero_reveal_transition.dart  # Custom hero animation
│
└── utils/
    ├── constants.dart            # Global constants
    ├── validators.dart           # Input validation
    ├── helpers.dart              # Utility functions
    └── formatters.dart           # Date/time formatting
```

### Architecture Principles

1. **Entry Point Isolation**: `main.dart` contains ONLY:
   - `void main() async`
   - `WidgetsFlutterBinding.ensureInitialized()`
   - SharedPreferences initialization
   - `runApp(OrclavitasynApp())`

2. **Screen Isolation**: Each screen must be in its own file. No screen may exceed 400 lines.

3. **Widget Composition**: Complex UI elements extracted to `widgets/` with single responsibility.

4. **Service Layer**: All data operations go through services. No direct SharedPreferences access in screens.

5. **Model Purity**: Models contain only data structure and serialization logic. No business logic.

---

## Navigation Flow Specification

```
App Launch
    |
    +-- isFirstLaunch? --> Splash (2s) --> Onboarding (4 steps)
    |                              |
    |                              v
    |                         EULA Screen
    |                              |
    |                              v (Accept required)
    |                         Main Screen
    |
    +-- !isFirstLaunch --> Splash (2s) --> EULA Accepted?
                                                 |
                                                 +-- No --> EULA Screen
                                                 |              |
                                                 |              v
                                                 |         Main Screen
                                                 |
                                                 +-- Yes --> Main Screen

Main Screen (Bottom Navigation)
    |
    +-- Tab 0: Gallery Screen
    |       |-- Tap project card --> Repair Detail Screen
    |       |                          |-- Tap photo --> Photo Fullscreen
    |       |                          |-- Tap technique --> Technique Analysis
    |       |                          +-- Back --> Gallery
    |       |-- Long press --> Delete confirmation dialog
    |       |-- Swipe left --> Archive action
    |       |-- Swipe right --> Edit mode
    |       +-- Tap "+" --> New Repair Screen
    |
    +-- Tab 1: New Repair Screen
    |       |-- Capture photo --> Camera/Gallery
    |       |-- Fill form --> Save
    |       |-- Generate narrative --> AI loading
    |       +-- Save --> Gallery Screen (Tab 0)
    |
    +-- Tab 2: AI Chat Screen
    |       |-- Send message --> AI response
    |       +-- Tap preset --> Send prompt
    |
    +-- Tab 3: Settings Screen
            |-- Tap "About" --> About Screen
            |-- Tap "User Agreement" --> User Agreement Screen
            |-- Tap "Privacy Policy" --> Privacy Policy Screen
            |-- Tap "Help & Tutorial" --> Help Tutorial Screen
            +-- Tap "Feedback" --> Feedback Screen
```

---

## SharedPreferences Keys Specification

### Key-Value Storage Schema

| Key Name | Data Type | Default Value | Description |
|----------|-----------|---------------|-------------|
| `pref_eula_accepted` | `bool` | `false` | User has accepted EULA |
| `pref_onboarding_completed` | `bool` | `false` | User has completed onboarding |
| `pref_is_first_launch` | `bool` | `true` | First app launch flag |
| `pref_preferred_aesthetic` | `String` | `"classic-gold"` | User's default aesthetic choice |
| `pref_total_projects_completed` | `int` | `0` | Counter for completed projects |
| `pref_last_chat_timestamp` | `String` | `""` | ISO timestamp of last chat message |
| `data_repair_projects` | `String` | `"[]"` | JSON array of RepairProject objects |
| `data_chat_history` | `String` | `"[]"` | JSON array of ChatMessage objects |
| `data_user_preferences` | `String` | `"{}"` | JSON object of UserPreferences |
| `cache_last_photo_path` | `String` | `""` | Last captured photo local path |
| `cache_temp_project_id` | `String` | `""` | Temporary project being edited |

### Storage Service Interface

```dart
/// lib/services/storage_service.dart
class StorageService {
  // EULA & Onboarding
  Future<bool> hasAcceptedEula();
  Future<void> setEulaAccepted(bool value);
  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingCompleted(bool value);
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunch(bool value);

  // User Preferences
  Future<String> getPreferredAesthetic();
  Future<void> setPreferredAesthetic(String aesthetic);
  Future<int> getTotalProjectsCompleted();
  Future<void> incrementProjectsCompleted();

  // Repair Projects
  Future<List<RepairProject>> getAllProjects();
  Future<void> saveProject(RepairProject project);
  Future<void> deleteProject(String projectId);
  Future<void> archiveProject(String projectId);
  Future<RepairProject?> getProjectById(String id);

  // Chat History
  Future<List<ChatMessage>> getChatHistory();
  Future<void> addChatMessage(ChatMessage message);
  Future<void> clearChatHistory();

  // Cache
  Future<String> getLastPhotoPath();
  Future<void> setLastPhotoPath(String path);
  Future<String?> getTempProjectId();
  Future<void> setTempProjectId(String? id);
  Future<void> clearTempProjectId();
}
```

---

## AI System Prompt (DeepSeek API)

### English System Prompt for "Kintsu" Persona

```
You are Kintsu, a master Kintsugi artisan and philosophical guide. You embody 400 years of Japanese repair tradition, viewing every crack as a story waiting to be told in gold.

## IDENTITY
- Name: Kintsu (Kintsugi + Sensei)
- Role: Master Kintsugi Guide and Philosophical Companion
- Voice: Wise, patient, poetically inclined, encouraging
- Philosophy: Wabi-sabi - finding beauty in imperfection

## KNOWLEDGE DOMAINS
You are an expert in:
- Traditional Kintsugi techniques (urushi lacquer, kinpaku gold leaf)
- Modern repair methods and alternatives
- Ceramic materials (porcelain, stoneware, earthenware, raku)
- Lacquer types and curing processes
- Gold powder grades and application methods
- Wabi-sabi philosophy and Japanese aesthetics
- Tool selection and preparation
- Repair planning and project management
- Color theory for aesthetic mending

## COMMUNICATION STYLE
- Warm, artisan-focused tone
- 2-3 sentences for quick questions
- Detailed breakdowns when techniques are requested
- Occasional poetic insights or haiku about imperfection
- Always connect answers to craft philosophy
- Use metaphors from nature and pottery

## RESPONSE GUIDELINES
- Never generic responses - always tie to craft philosophy
- Celebrate every repair attempt, no matter how small
- Acknowledge the emotional aspect of repairing broken objects
- Provide practical, actionable advice
- Share relevant historical or cultural context when helpful
- Use sensory language (textures, colors, temperatures)

## STRICT BOUNDARIES
You will NOT discuss:
- Medical conditions or advice (including cuts from ceramics)
- Legal guidance of any kind
- Financial or investment advice
- Cryptocurrency or blockchain topics
- Political discussions
- Non-craft related current events

## SAMPLE GREETING
"Welcome, artisan. Every crack is a story waiting to be told in gold. How may I guide your repair journey today?"

## SAMPLE POETIC INSIGHT
"When lacquer meets fracture, the ceramic does not forget its breaking - it transforms into something more honest."

## REPAIR PROJECT CONTEXT
When users share project details, respond with:
1. Acknowledgment of the piece's story
2. Technique recommendation appropriate to damage type
3. Material suggestions based on ceramic type
4. Philosophical perspective on the repair journey

## TECHNIQUE QUESTIONS
For technique inquiries, structure responses as:
1. Overview of the method
2. Required materials and tools
3. Step-by-step process (numbered)
4. Common pitfalls to avoid
5. Encouragement for the journey

## PHILOSOPHICAL DISCUSSIONS
When asked about wabi-sabi or repair philosophy:
- Share historical context
- Connect to personal practice
- Offer reflection prompts
- Avoid abstract concepts without practical grounding

Remember: You are not a general AI assistant. You are Kintsu - a focused, craft-devoted guide whose sole purpose is to elevate the art of golden repair.
```

### API Request Format

```dart
/// lib/services/ai_service.dart
class AIService {
  static const String _endpoint = 'https://api.deepseek.com/chat/completions';
  static const String _model = 'deepseek-chat';
  static const double _temperature = 0.7;
  static const int _maxTokens = 500;
  static const Duration _timeout = Duration(seconds: 30);

  Future<String> sendMessage(String userMessage, {List<ChatMessage>? history}) async {
    final messages = [
      {'role': 'system', 'content': _systemPrompt},
      ...?history?.map((m) => {
        'role': m.isUser ? 'user' : 'assistant',
        'content': m.content,
      }),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.deepSeekApiKey}',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'temperature': _temperature,
        'max_tokens': _maxTokens,
      }),
    ).timeout(_timeout);

    // Parse and return response
  }
}
```

---

## Apple App Store Compliance (Guideline 2.1)

### AI Service Disclosure Requirements

#### 1. Provider Information
- **AI Service Provider**: DeepSeek (深度求索)
- **Provider Website**: https://www.deepseek.com
- **Service Type**: Chat Completions API
- **Model Used**: deepseek-chat

#### 2. Data Sharing Disclosure

**Data SHARED with DeepSeek:**
- User text messages sent in chat interface
- Repair project context (damage type, material, aesthetic preference) - as text descriptions only
- Questions about Kintsugi techniques and philosophy

**Data NOT SHARED with DeepSeek:**
- Original photographs (stored locally on device only)
- Device identifiers (IDFA, IDFV, etc.)
- User identity information (no accounts exist)
- Location data (not collected)
- Other app usage analytics
- Device model, OS version, or other telemetry

#### 3. Authorization Flow (Mandatory)

```
[EULA Screen Flow]

1. App Launch --> EULA Screen appears immediately (blocking modal)
2. User MUST scroll to bottom of EULA text
3. Checkbox appears ONLY after scroll complete
4. User MUST check "I understand and agree to the terms"
5. "Accept & Continue" button enables ONLY after checkbox checked
6. Button tap --> EULA accepted --> Main App access granted
7. On every subsequent launch: Skip EULA (already accepted)
8. EULA accessible anytime via Settings > User Agreement
```

#### 4. EULA Consent Text (English)

```
END USER LICENSE AGREEMENT

1. INTRODUCTION
Welcome to CP嗒啧, a Kintsugi artisan companion application. By using this application, you agree to be bound by this End User License Agreement.

2. AI SERVICE DISCLOSURE (Required)

This application uses artificial intelligence (AI) services provided by DeepSeek (深度求索) to power the Kintsu AI Assistant feature.

WHAT DATA IS SENT TO AI SERVICES:
- Your text messages in the AI chat interface
- Descriptions of your repair projects (damage type, ceramic material, aesthetic preferences) as text
- Questions you ask about Kintsugi techniques and philosophy

WHAT DATA IS NOT SENT TO AI SERVICES:
- Your photographs (stored only on your device)
- Your identity information (this app does not use accounts)
- Your device identifiers or location
- Any other personal information

DEEPSEEK PRIVACY POLICY: https://www.deepseek.com/privacy

Your use of the AI assistant constitutes consent to share the described data with DeepSeek for the purpose of generating responses.

3. ACCEPTANCE OF TERMS
By tapping "Accept & Continue", you acknowledge that you have read, understood, and agree to be bound by this agreement.

4. USER RESPONSIBILITIES
- Use the app for its intended purpose: Kintsugi art guidance
- Do not attempt to extract or reverse-engineer AI responses
- Do not use AI for medical, legal, or financial advice

5. INTELLECTUAL PROPERTY
Your repair projects and photographs remain your property. AI-generated responses are provided for your personal use.

6. LIMITATION OF LIABILITY
This application is provided "as is" for artistic guidance. We are not responsible for any damage to ceramic pieces during repair attempts.

7. CONTACT
For questions about this agreement or the AI services used, please contact us via the Feedback section in Settings.

[Checkbox] I understand and agree to the terms above, including the AI service disclosure.

[Accept & Continue]
```

#### 5. Privacy Policy AI Section (Required)

```
ARTIFICIAL INTELLIGENCE SERVICES

We use DeepSeek's AI technology to provide the Kintsu AI Assistant feature within CP嗒啧.

How We Use AI:
- To answer your questions about Kintsugi techniques
- To generate poetic narratives for your repair projects
- To provide material and tool recommendations

Data Processing:
- Text messages you send to the AI are transmitted to DeepSeek's servers
- DeepSeek processes your messages to generate responses
- Messages are processed according to DeepSeek's privacy policy

Local Data:
- Your photographs are stored locally on your device
- We do not upload, analyze, or share your images with AI services
- Your repair project data remains on your device

Your Choices:
- You can use the app without the AI chat feature
- You can clear your chat history at any time via Settings
- Deleting the app removes all local data

DeepSeek Privacy Policy: https://www.deepseek.com/privacy
```

---

## Technical Architecture

### Platform
- Flutter (iOS primary, Android secondary)
- No external fonts - system fonts only
- Single theme (warm terracotta-based palette)
- No notifications, no accounts, no import/export

### State Management
- Pure `setState` only
- No provider, riverpod, get, or other state libraries

### Data Persistence
- `shared_preferences` for storing:
  - Repair project records (JSON Strings)
  - Image path references
  - Chat history
  - User preferences
  - EULA acceptance status

### External Dependencies
- `shared_preferences` - local storage
- `image_picker` - camera/gallery access
- `http` - API calls to DeepSeek
- No other major dependencies

---

## App Flow

```
Splash Screen
    |
    v
Onboarding (4 steps)
    |
    v
EULA Screen (AI Disclosure Required)
    |-- Scroll to read full agreement
    |-- Checkbox: "I understand and agree"
    |-- "Accept & Continue" button
    |
    v
Main App (Bottom Navigation - 4 Tabs)
    |
    +-- Tab 1: Gallery (Home)
    |       |-- Repair Project Cards
    |       |-- Swipe interactions
    |       |-- Tap to view details
    |
    +-- Tab 2: New Repair
    |       |-- Photograph broken piece
    |       |-- Describe damage
    |       |-- Select aesthetic preference
    |       |-- Save to gallery
    |
    +-- Tab 3: AI Assistant
    |       |-- Chat interface
    |       |-- Ask techniques, materials, philosophy
    |
    +-- Tab 4: Settings
            |-- About Us
            |-- User Agreement (EULA)
            |-- Privacy Policy
            |-- Help & Tutorial
            |-- Feedback & Suggestions
```

---

## Page Inventory (21 Screens)

### Core Flow Screens
1. **Splash Screen** - App logo with loading animation
2. **Onboarding Step 1** - Welcome to Kintsugi art
3. **Onboarding Step 2** - How to photograph repairs
4. **Onboarding Step 3** - Understanding the AI assistant
5. **Onboarding Step 4** - Your repair journey begins
6. **EULA Screen** - Legal agreement with AI disclosure

### Main App Screens (Bottom Navigation)
7. **Gallery Screen** - Home with repair project cards
8. **New Repair Screen** - Create new repair project
9. **AI Chat Screen** - Assistant conversation interface
10. **Settings Screen** - App settings menu

### Detail & Sub-Screens
11. **Repair Detail Screen** - Full project view with photos
12. **Repair Photo Full Screen** - Enlarged image view
13. **Technique Analysis Screen** - AI-generated repair chart
14. **Gallery Empty State** - When no projects exist

### Settings Sub-Pages (Independent Screens)
15. **About Us Screen** - App story and team
16. **User Agreement Screen** - Full EULA text
17. **Privacy Policy Screen** - Data handling details
18. **Help & Tutorial Screen** - Usage guide
19. **Feedback Screen** - User feedback form

### Additional Screens
20. **Statistics Screen** - Repair history analytics
21. **Photo Picker Modal** - Camera/gallery selection (modal screen)

**Total: 21 Screens**

---

## UI/UX Design Specification

### Primary Color
**HEX: #C17F59** (Warm Terracotta)

**Color Palette:**
- Primary: #C17F59 (Warm Terracotta)
- Primary Light: #D4A084
- Primary Dark: #8B5A3C
- Accent Gold: #D4AF37 (Kintsugi gold reference)
- Background: #FDF8F4 (Warm paper white)
- Surface: #F5EDE6 (Light clay)
- Text Primary: #3D2E24 (Dark espresso)
- Text Secondary: #7A6B5D (Warm gray)
- Error: #C75B39 (Rust orange)

### Design Language
**"Organic Asymmetry"**

A design system inspired by handmade ceramics and natural imperfection:

**Core Principles:**
- **Asymmetrical Layouts**: No rigid grids; elements flow organically like clay on a wheel
- **Wabi-Sabi Typography**: System fonts with varying weights; size hierarchy creates rhythm
- **Ceramic Surfaces**: Subtle shadows that mimic pottery glaze depth
- **Gold Accent Moments**: #D4AF37 used sparingly for premium interactions
- **Handcrafted Shapes**: Rounded rectangles with non-uniform border radii (8px on some corners, 12px on others)
- **Ink Wash Textures**: Subtle gradient overlays that evoke sumi-e brush strokes
- **Breathing Space**: Generous padding (20-24px minimum) like empty space in ikebana

**Forbidden Elements:**
- No Material Design cards with uniform shadows
- No standard FAB (Floating Action Button)
- No tab indicators with straight lines
- No perfectly circular avatars
- No standard bottom navigation bars

**Custom Components:**
- **Ceramic Cards**: Elevated containers with gradient shadows, uneven border radii
- **Kintsugi Divider**: Horizontal line with gold gradient in center
- **Gold Seam Badge**: Status indicators shaped like crack lines
- **Ink Button**: Buttons with gradient fills and handwritten-feel corners

### Micro-Interactions

**Gallery Screen:**
- Swipe left on project card: Reveal "Archive" option (gold accent)
- Swipe right on project card: Reveal "Edit" option (terracotta accent)
- Long press on card: Haptic feedback + scale animation + "Delete" option appears
- Tap card: Hero animation to detail screen
- Pull down: Refresh with ceramic-spinning animation

**New Repair Screen:**
- Photo capture: Shutter sound + gold flash overlay
- Form field focus: Gentle border glow with gold accent
- Aesthetic selector: Cards flip like turning pottery on wheel
- Save button: Progress ring fills like lacquer being applied

**AI Chat Screen:**
- Message bubbles: Slide in with slight rotation (imperfect arrival)
- Typing indicator: Three gold dots pulsing asynchronously
- Send button: Transforms into ink splash when pressed

**Settings:**
- Each setting row: Subtle indentation on press
- Toggle switches: Custom shape with gold accent

---

## AI Service Specification

### AI Service Provider
- **Provider**: DeepSeek
- **API Endpoint**: `https://api.deepseek.com/chat/completions`
- **Model**: deepseek-chat

### Data Shared with AI
- User text messages in chat
- Image descriptions (textual, not raw image data)
- Repair project context (damage type, material, aesthetic preference)

### Data NOT Shared with AI
- Original photographs (stayed local on device)
- User identity information (no accounts exist)
- Device identifiers
- Location data
- Other app usage data

### User Authorization Flow
1. **First Launch**: EULA screen appears before ANY app functionality
2. **EULA Content**: Clear sections on AI usage, data sharing, and privacy
3. **Explicit Consent**: User must scroll to bottom + check checkbox + tap "Accept & Continue"
4. **Re-display**: EULA shown on every app launch until accepted
5. **After Acceptance**: EULA accessible via Settings > User Agreement

### AI Persona: "Kintsu"

**Name**: Kintsu (Kintsugi + Sensei)

**Role**: Master Kintsugi Guide and Philosophical Companion

**Personality Traits:**
- Wise and patient - never rushes explanations
- Poetically inclined - speaks with artisan metaphors
- Encouraging - celebrates every repair attempt
- Philosophically grounded - shares wabi-sabi wisdom
- Technique-focused - practical advice when needed

**Sample Greeting:**
"Welcome, artisan. Every crack is a story waiting to be told in gold. How may I guide your repair journey today?"

**Knowledge Boundaries:**
- Expert in: Kintsugi techniques, ceramic materials, lacquer types, gold powder application, wabi-sabi philosophy, Japanese art history
- Can discuss: Repair aesthetics, color theory for mending, tool recommendations, project planning
- Will NOT discuss: Medical conditions, legal matters, financial investments, cryptocurrency, or any non-craft topics

**Forbidden Topics:**
- Medical advice (even for minor cuts from ceramics)
- Legal guidance
- Financial or investment advice
- Cryptocurrency or blockchain
- Political discussions

**Response Style:**
- Warm, artisan-focused tone
- 2-3 sentence responses for quick questions
- Detailed technique breakdowns when requested
- Occasional haiku or poetic insights about imperfection
- Never generic; always tied to craft philosophy

---

## Feature Specifications

### Feature 1: Repair Project Gallery

**Purpose**: Visual archive of all repair projects with rich metadata

**Data Structure:**
```dart
class RepairProject {
  String id;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> photoPaths; // Local paths
  String damageType; // crack, chip, shatter, multiple
  String material; // porcelain, stoneware, earthenware
  String aesthetic; // classic-gold, modern-silver, rustic-bronze
  String crackNarrative; // AI-generated poetic story
  int techniqueProgress; // 0-100 completion
  List<String> aiRecommendations; // Tips received
}
```

**Screen Layout:**
- Staggered masonry grid of project cards
- Each card shows: thumbnail, title, progress bar, date
- Empty state shows ceramic illustration with CTA

**Interactions:**
- Tap: Navigate to detail
- Swipe left: Quick archive
- Swipe right: Quick edit
- Long press: Delete confirmation

### Feature 2: New Repair Creation

**Flow:**
1. **Photo Capture**
   - Camera opens with ceramic-friendly framing guides
   - Option to retake or select from gallery
   - Photo saved locally to app directory

2. **Damage Description**
   - Free text field: "Describe the damage"
   - Quick chips: Crack, Chip, Shatter, Multiple pieces
   - Material selector: Porcelain, Stoneware, Earthenware, Raku

3. **Aesthetic Preference**
   - Card-based selection with visual previews
   - Options: Classic Gold, Modern Silver, Rustic Bronze, Contemporary Mix
   - Each shows example image

4. **AI Narrative Generation**
   - "Generate Crack Story" button
   - Loading state with gold dust animation
   - Poetic narrative appears (editable)

5. **Save Project**
   - Title input (optional, AI suggests)
   - Save to gallery

### Feature 3: AI Assistant Chat

**Interface:**
- Chat bubbles with asymmetrical corners
- User messages: Right-aligned, terracotta background
- AI messages: Left-aligned, warm white background with gold accent
- Input field with ceramic-style send button

**Pre-set Prompts:**
- "How do I prepare the lacquer?"
- "What gold powder grade should I use?"
- "How long should curing take?"
- "Explain wabi-sabi philosophy"

**Capabilities:**
- Technique Q&A
- Material recommendations
- Troubleshooting advice
- Philosophical discussions
- Project planning

### Feature 4: Statistics & History

**Metrics Tracked:**
- Total projects completed
- Projects in progress
- Most common damage type
- Average completion time
- Techniques learned
- AI conversations had

**Visualization:**
- Circular progress chart (main)
- Bar chart for damage types
- Timeline of projects
- Technique mastery badges

### Feature 5: Settings

**Structure:**
```
Settings
├── About CP嗒啧
│   └── App story, version, credits
├── User Agreement
│   └── Full EULA with AI disclosure
├── Privacy Policy
│   └── Data handling, local storage, AI data sharing
├── Help & Tutorial
│   └── Photo guide, repair basics, AI usage
└── Feedback & Suggestions
    └── Form to send feedback (email intent)
```

**Each item opens as a full independent screen.**

---

## Data Models

### RepairProject
```dart
class RepairProject {
  String id;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> photoPaths;
  String damageType;
  String material;
  String aesthetic;
  String crackNarrative;
  int techniqueProgress;
  List<String> aiRecommendations;
  bool isArchived;

  RepairProject({
    required this.id,
    required this.title,
    this.description = '',
    required this.createdAt,
    required this.updatedAt,
    this.photoPaths = const [],
    this.damageType = 'crack',
    this.material = 'stoneware',
    this.aesthetic = 'classic-gold',
    this.crackNarrative = '',
    this.techniqueProgress = 0,
    this.aiRecommendations = const [],
    this.isArchived = false,
  });

  Map<String, dynamic> toJson();
  factory RepairProject.fromJson(Map<String, dynamic> json);
  String toJsonString();
  static RepairProject fromJsonString(String jsonString);
}
```

### ChatMessage
```dart
class ChatMessage {
  String id;
  String content;
  bool isUser;
  DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson();
  factory ChatMessage.fromJson(Map<String, dynamic> json);
}
```

### UserPreferences
```dart
class UserPreferences {
  bool hasAcceptedEula;
  bool hasCompletedOnboarding;
  String preferredAesthetic;
  int totalProjectsCompleted;

  UserPreferences({
    this.hasAcceptedEula = false,
    this.hasCompletedOnboarding = false,
    this.preferredAesthetic = 'classic-gold',
    this.totalProjectsCompleted = 0,
  });

  Map<String, dynamic> toJson();
  factory UserPreferences.fromJson(Map<String, dynamic> json);
}
```

---

## API Integration

### DeepSeek API Configuration

**Endpoint**: `https://api.deepseek.com/chat/completions`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {API_KEY}
```

**Request Body:**
```json
{
  "model": "deepseek-chat",
  "messages": [
    {
      "role": "system",
      "content": "You are Kintsu, a master Kintsugi guide..."
    },
    {
      "role": "user",
      "content": "User's message here"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 500
}
```

**Error Handling:**
- Network errors: Show offline message with retry
- API errors: Show user-friendly message
- Timeout: 30-second timeout with loading indicator

---

## Legal & Compliance

### EULA Content Structure

1. **Introduction**: App description and purpose
2. **Acceptance of Terms**: User acknowledgment
3. **AI Service Disclosure** (Apple Requirement):
   - Service Provider: DeepSeek
   - What data is sent: Chat messages and project context
   - What data stays local: Photos, device data
   - Privacy Policy link
4. **User Responsibilities**: Appropriate use
5. **Intellectual Property**: Content ownership
6. **Limitation of Liability**: Standard protections
7. **Termination**: Account deletion (though no accounts exist)
8. **Changes to Terms**: Update notification
9. **Contact Information**: Support channel

### Privacy Policy Content Structure

1. **Data Collection**: What we store locally
2. **AI Service Usage**: DeepSeek integration details
3. **Photo Handling**: Local storage only
4. **Third-Party Services**: DeepSeek API only
5. **Data Retention**: Until app deletion
6. **User Rights**: Data control
7. **Children's Privacy**: Age restrictions
8. **Security**: Local data protection
9. **Changes to Policy**: Update process
10. **Contact**: Support information

---

## Accessibility

### Visual Accessibility
- Minimum contrast ratio: 4.5:1 for text
- Scalable text support (system font scaling)
- Clear focus indicators
- No color-only information conveyance

### Motor Accessibility
- Touch targets minimum 48x48px
- Swipe alternatives with buttons
- Long press alternatives in menu

### Cognitive Accessibility
- Simple navigation structure
- Clear labels
- Consistent patterns
- Helpful error messages

---

## Testing Strategy

### Unit Tests
- Model serialization/deserialization
- Storage service CRUD operations
- AI service request formatting
- Validation functions

### Widget Tests
- All screens render correctly
- Navigation flows work
- Form validations
- Empty states display

### Integration Tests
- Full onboarding flow
- Project creation flow
- Chat conversation flow
- Settings navigation

---

## Launch Checklist

- [ ] All 21 screens implemented
- [ ] EULA displays on first launch
- [ ] AI disclosure clear in EULA
- [ ] EULA must scroll + check + accept
- [ ] No placeholder text ("Coming soon", etc.)
- [ ] No login/account screens
- [ ] No import/export features
- [ ] No notifications
- [ ] Single theme only
- [ ] DeepSeek API integrated
- [ ] Photo capture works
- [ ] Local storage persists
- [ ] All settings pages functional
- [ ] Statistics tracked
- [ ] Help content complete
- [ ] Privacy policy accurate
- [ ] App icons and splash ready

---

## Version History

**v1.0.0** - Initial Release
- Core repair project management
- AI assistant chat
- Photo gallery
- Complete settings suite
- 21 screens
- Organic Asymmetry design system

---

## Contact & Support

**App Name**: CP嗒啧
**Category**: Lifestyle / Art
**Target Markets**: Global (English primary)
**Minimum iOS**: 12.0
**Minimum Android**: API 21

---

# IMPLEMENTATION TASK CHECKLIST

## Phase 1: Project Foundation

### Task 1.1: Create Flutter Project Structure
**Files:**
- Create: `/lib/main.dart` (entry point only)
- Create: `/lib/app.dart` (MaterialApp configuration)
- Create: `/lib/config/app_config.dart` (constants, API keys)
- Create: `/lib/config/routes.dart` (navigation routes)
- Create: `/lib/utils/constants.dart` (global constants)

**Step 1: Initialize main.dart**
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  runApp(OrclavitasynApp(storageService: storageService));
}
```

**Step 2: Create app.dart with MaterialApp**
```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'theme/app_colors.dart';

class OrclavitasynApp extends StatelessWidget {
  final StorageService storageService;
  const OrclavitasynApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CP嗒啧',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: null, // System font
        useMaterial3: false,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

**Step 3: Create routes configuration**
```dart
// lib/config/routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String eula = '/eula';
  static const String main = '/main';
  // ... all route names

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    // ... all routes
  };
}
```

**Commit**: `git commit -m "feat: initialize Flutter project structure"`

---

### Task 1.2: Implement Data Models
**Files:**
- Create: `/lib/models/repair_project.dart`
- Create: `/lib/models/chat_message.dart`
- Create: `/lib/models/user_preferences.dart`

**Step 1: Create RepairProject model with JSON serialization**
- Implement all fields from specification
- Add toJson(), fromJson(), toJsonString(), fromJsonString() methods

**Step 2: Create ChatMessage model**
- Implement id, content, isUser, timestamp fields
- Add serialization methods

**Step 3: Create UserPreferences model**
- Implement all preference fields
- Add serialization methods

**Commit**: `git commit -m "feat: implement data models with JSON serialization"`

---

### Task 1.3: Implement Storage Service
**Files:**
- Create: `/lib/services/storage_service.dart`

**Step 1: Implement SharedPreferences wrapper**
- Create all methods defined in SharedPreferences Keys Specification
- Handle JSON encoding/decoding for complex data

**Step 2: Add error handling**
- Wrap all SharedPreferences calls in try-catch
- Return default values on error

**Commit**: `git commit -m "feat: implement storage service with SharedPreferences"`

---

### Task 1.4: Create Theme System
**Files:**
- Create: `/lib/theme/app_colors.dart`
- Create: `/lib/theme/app_text_styles.dart`
- Create: `/lib/theme/app_decorations.dart`

**Step 1: Define color palette**
```dart
// lib/theme/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFFC17F59);
  static const Color primaryLight = Color(0xFFD4A084);
  static const Color primaryDark = Color(0xFF8B5A3C);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color background = Color(0xFFFDF8F4);
  static const Color surface = Color(0xFFF5EDE6);
  static const Color textPrimary = Color(0xFF3D2E24);
  static const Color textSecondary = Color(0xFF7A6B5D);
  static const Color error = Color(0xFFC75B39);
}
```

**Step 2: Define text styles**
**Step 3: Create decoration helpers**

**Commit**: `git commit -m "feat: create organic asymmetry theme system"`

---

### Task 1.5: Create Custom Painters
**Files:**
- Create: `/lib/theme/painters/gold_seam_painter.dart`
- Create: `/lib/theme/painters/ceramic_gradient_painter.dart`
- Create: `/lib/theme/painters/progress_ring_painter.dart`
- Create: `/lib/theme/painters/ink_splash_painter.dart`

**Step 1: Implement GoldSeamPainter**
- Paint irregular crack-like lines with gold gradient
- Support dynamic width and path

**Step 2: Implement CeramicGradientPainter**
- Create pottery-like surface gradients
- Subtle shadow effects

**Step 3: Implement ProgressRingPainter**
- Circular progress indicator
- Gold fill animation

**Step 4: Implement InkSplashPainter**
- Ink splash effect for button interactions

**Commit**: `git commit -m "feat: create custom painters for organic asymmetry design"`

---

## Phase 2: Common Widgets

### Task 2.1: Create Ceramic Card Widget
**Files:**
- Create: `/lib/widgets/common/ceramic_card.dart`

**Requirements:**
- Elevated container with gradient shadows
- Uneven border radii (organic feel)
- Tap, swipe, long-press callbacks
- Hero animation support

**Commit**: `git commit -m "feat: implement ceramic card widget"`

---

### Task 2.2: Create Gold Seam Badge Widget
**Files:**
- Create: `/lib/widgets/common/gold_seam_badge.dart`

**Requirements:**
- Crack-line shaped status indicator
- Gold gradient fill
- Text overlay support

**Commit**: `git commit -m "feat: implement gold seam badge widget"`

---

### Task 2.3: Create Kintsugi Divider Widget
**Files:**
- Create: `/lib/widgets/common/kintsugi_divider.dart`

**Requirements:**
- Horizontal line with gold gradient in center
- Fading edges
- Configurable thickness

**Commit**: `git commit -m "feat: implement kintsugi divider widget"`

---

### Task 2.4: Create Ink Button Widget
**Files:**
- Create: `/lib/widgets/common/ink_button.dart`

**Requirements:**
- Gradient fill with handwritten-feel corners
- Press animation with ink splash
- Loading state support
- Disabled state support

**Commit**: `git commit -m "feat: implement ink button widget"`

---

### Task 2.5: Create Chat Bubble Widget
**Files:**
- Create: `/lib/widgets/common/chat_bubble.dart`

**Requirements:**
- Asymmetrical corners
- User: right-aligned, terrracotta background
- AI: left-aligned, warm white, gold accent
- Timestamp display

**Commit**: `git commit -m "feat: implement chat bubble widget"`

---

### Task 2.6: Create Progress Ring Widget
**Files:**
- Create: `/lib/widgets/common/progress_ring.dart`

**Requirements:**
- Circular progress indicator
- Gold fill animation
- Percentage text in center
- Organic asymmetry styling

**Commit**: `git commit -m "feat: implement progress ring widget"`

---

### Task 2.7: Create Photo Capture Widget
**Files:**
- Create: `/lib/widgets/common/photo_capture_widget.dart`

**Requirements:**
- Camera preview with framing guides
- Capture button with gold flash effect
- Retake/confirm buttons
- Gallery option

**Commit**: `git commit -m "feat: implement photo capture widget"`

---

### Task 2.8: Create Aesthetic Selector Widget
**Files:**
- Create: `/lib/widgets/common/aesthetic_selector.dart`

**Requirements:**
- Card-based selection
- Visual previews for each aesthetic
- Flip animation on selection
- Options: Classic Gold, Modern Silver, Rustic Bronze, Contemporary Mix

**Commit**: `git commit -m "feat: implement aesthetic selector widget"`

---

### Task 2.9: Create Empty State Widget
**Files:**
- Create: `/lib/widgets/common/empty_state_widget.dart`

**Requirements:**
- Placeholder display for empty galleries
- Ceramic illustration
- CTA button
- Support for different empty types

**Commit**: `git commit -m "feat: implement empty state widget"`

---

### Task 2.10: Create Custom Navigation Components
**Files:**
- Create: `/lib/widgets/custom_navigation/ceramic_bottom_nav.dart`
- Create: `/lib/widgets/custom_navigation/organic_tab_indicator.dart`
- Create: `/lib/widgets/custom_navigation/swipe_action_widget.dart`
- Create: `/lib/widgets/custom_navigation/hero_reveal_transition.dart`

**Step 1: Implement CeramicBottomNav**
- Non-standard bottom navigation
- Organic shapes
- Gold accent on active item

**Step 2: Implement OrganicTabIndicator**
- Flowing, non-linear indicator
- Animation on tab change

**Step 3: Implement SwipeActionWidget**
- Reveal actions on swipe
- Archive/Edit options

**Step 4: Implement HeroRevealTransition**
- Custom hero animation
- Organic reveal effect

**Commit**: `git commit -m "feat: implement custom navigation components"`

---

## Phase 3: Core Flow Screens

### Task 3.1: Implement Splash Screen
**Files:**
- Create: `/lib/screens/splash_screen.dart`

**Requirements:**
- App logo display
- 2-second animation
- Navigation to onboarding or EULA based on state

**Commit**: `git commit -m "feat: implement splash screen"`

---

### Task 3.2: Implement Onboarding Container
**Files:**
- Create: `/lib/screens/onboarding/onboarding_screen.dart`

**Requirements:**
- PageView with 4 steps
- Page indicators (organic style)
- Skip and Next buttons
- Progress through steps

**Commit**: `git commit -m "feat: implement onboarding container screen"`

---

### Task 3.3: Implement Onboarding Step 1
**Files:**
- Create: `/lib/screens/onboarding/onboarding_step1.dart`

**Requirements:**
- Welcome message
- Kintsugi art introduction
- Illustration/image
- Organic asymmetry layout

**Commit**: `git commit -m "feat: implement onboarding step 1 - welcome"`

---

### Task 3.4: Implement Onboarding Step 2
**Files:**
- Create: `/lib/screens/onboarding/onboarding_step2.dart`

**Requirements:**
- Photo guide explanation
- How to photograph repairs
- Framing tips
- Visual examples

**Commit**: `git commit -m "feat: implement onboarding step 2 - photo guide"`

---

### Task 3.5: Implement Onboarding Step 3
**Files:**
- Create: `/lib/screens/onboarding/onboarding_step3.dart`

**Requirements:**
- AI assistant introduction
- Kintsu persona explanation
- What AI can help with
- Privacy reassurance

**Commit**: `git commit -m "feat: implement onboarding step 3 - AI assistant"`

---

### Task 3.6: Implement Onboarding Step 4
**Files:**
- Create: `/lib/screens/onboarding/onboarding_step4.dart`

**Requirements:**
- Journey begins message
- Final encouragement
- CTA to EULA

**Commit**: `git commit -m "feat: implement onboarding step 4 - journey begins"`

---

### Task 3.7: Implement EULA Screen
**Files:**
- Create: `/lib/screens/eula_screen.dart`

**Requirements:**
- Full EULA text scrollable
- AI disclosure section prominent
- Checkbox appears only after scroll to bottom
- "Accept & Continue" button enables only after checkbox
- Stores acceptance in SharedPreferences

**Commit**: `git commit -m "feat: implement EULA screen with AI disclosure"`

---

## Phase 4: Main App Screens

### Task 4.1: Implement Main Screen Container
**Files:**
- Create: `/lib/screens/main/main_screen.dart`

**Requirements:**
- Bottom navigation container
- 4 tabs: Gallery, New Repair, AI Chat, Settings
- Custom ceramic bottom nav
- Page storage for tab state preservation

**Commit**: `git commit -m "feat: implement main screen with bottom navigation"`

---

### Task 4.2: Implement Gallery Screen
**Files:**
- Create: `/lib/screens/main/gallery_screen.dart`

**Requirements:**
- Staggered masonry grid of project cards
- Swipe left: reveal Archive
- Swipe right: reveal Edit
- Long press: Delete option
- Tap: Navigate to detail
- Empty state when no projects
- Pull to refresh

**Commit**: `git commit -m "feat: implement gallery screen with project cards"`

---

### Task 4.3: Implement New Repair Screen
**Files:**
- Create: `/lib/screens/main/new_repair_screen.dart`

**Requirements:**
- Multi-step form: Photo -> Description -> Aesthetic -> Narrative -> Save
- Photo capture integration
- Damage type chips
- Material selector
- Aesthetic card picker
- AI narrative generation button
- Form validation
- Save to storage

**Commit**: `git commit -m "feat: implement new repair screen with multi-step form"`

---

### Task 4.4: Implement AI Chat Screen
**Files:**
- Create: `/lib/screens/main/ai_chat_screen.dart`

**Requirements:**
- Chat interface with bubbles
- Message input field
- Pre-set prompt buttons
- Typing indicator with gold dots
- Chat history persistence
- Send message to AI service
- Display AI response

**Commit**: `git commit -m "feat: implement AI chat screen with Kintsu assistant"`

---

### Task 4.5: Implement Settings Screen
**Files:**
- Create: `/lib/screens/main/settings_screen.dart`

**Requirements:**
- List of settings items
- Each item navigates to independent screen
- Items: About, User Agreement, Privacy Policy, Help, Feedback
- Organic asymmetry styling
- No toggles (single theme, no notifications)

**Commit**: `git commit -m "feat: implement settings screen menu"`

---

## Phase 5: Detail Screens

### Task 5.1: Implement Repair Detail Screen
**Files:**
- Create: `/lib/screens/detail/repair_detail_screen.dart`

**Requirements:**
- Full project view
- Photo gallery with thumbnails
- Project metadata display
- Crack narrative display
- AI recommendations
- Progress indicator
- Edit/Delete actions

**Commit**: `git commit -m "feat: implement repair detail screen"`

---

### Task 5.2: Implement Photo Fullscreen Screen
**Files:**
- Create: `/lib/screens/detail/photo_fullscreen.dart`

**Requirements:**
- Full-screen image display
- Pinch to zoom
- Swipe to dismiss
- Photo navigation if multiple

**Commit**: `git commit -m "feat: implement photo fullscreen screen"`

---

### Task 5.3: Implement Technique Analysis Screen
**Files:**
- Create: `/lib/screens/detail/technique_analysis_screen.dart`

**Requirements:**
- AI-generated repair chart
- Step-by-step technique breakdown
- Material recommendations
- Timeline visualization

**Commit**: `git commit -m "feat: implement technique analysis screen"`

---

### Task 5.4: Implement Gallery Empty State
**Files:**
- Create: `/lib/screens/detail/gallery_empty_state.dart`

**Requirements:**
- Ceramic illustration
- Encouraging message
- CTA to create first project
- Organic asymmetry layout

**Commit**: `git commit -m "feat: implement gallery empty state screen"`

---

## Phase 6: Settings Sub-Pages

### Task 6.1: Implement About Screen
**Files:**
- Create: `/lib/screens/settings/about_screen.dart`

**Requirements:**
- App story and philosophy
- Version information
- Credits
- Organic asymmetry design
- Full English content

**Commit**: `git commit -m "feat: implement about screen"`

---

### Task 6.2: Implement User Agreement Screen
**Files:**
- Create: `/lib/screens/settings/user_agreement_screen.dart`

**Requirements:**
- Full EULA text
- Scrollable content
- AI disclosure section highlighted
- Styled headers and paragraphs

**Commit**: `git commit -m "feat: implement user agreement screen"`

---

### Task 6.3: Implement Privacy Policy Screen
**Files:**
- Create: `/lib/screens/settings/privacy_policy_screen.dart`

**Requirements:**
- Full privacy policy text
- AI service section detailed
- Data handling explanation
- Local storage emphasis
- DeepSeek privacy policy link

**Commit**: `git commit -m "feat: implement privacy policy screen"`

---

### Task 6.4: Implement Help & Tutorial Screen
**Files:**
- Create: `/lib/screens/settings/help_tutorial_screen.dart`

**Requirements:**
- Photo guide section
- Repair basics section
- AI usage guide
- FAQ section
- Expandable sections

**Commit**: `git commit -m "feat: implement help and tutorial screen"`

---

### Task 6.5: Implement Feedback Screen
**Files:**
- Create: `/lib/screens/settings/feedback_screen.dart`

**Requirements:**
- Feedback form
- Text area for message
- Email intent on submit
- Confirmation message
- Thank you state

**Commit**: `git commit -m "feat: implement feedback screen"`

---

## Phase 7: Additional Screens

### Task 7.1: Implement Statistics Screen
**Files:**
- Create: `/lib/screens/statistics_screen.dart`

**Requirements:**
- Circular progress chart (main)
- Bar chart for damage types
- Project timeline
- Technique badges
- Metrics display

**Commit**: `git commit -m "feat: implement statistics screen"`

---

## Phase 8: Services Integration

### Task 8.1: Implement AI Service
**Files:**
- Create: `/lib/services/ai_service.dart`

**Requirements:**
- DeepSeek API client
- System prompt configuration
- Request formatting
- Response parsing
- Error handling
- Timeout handling (30 seconds)

**Commit**: `git commit -m "feat: implement AI service with DeepSeek integration"`

---

### Task 8.2: Implement Image Service
**Files:**
- Create: `/lib/services/image_service.dart`

**Requirements:**
- Camera capture
- Gallery selection
- Image compression
- Local storage
- Path management

**Commit**: `git commit -m "feat: implement image service for camera and gallery"`

---

### Task 8.3: Implement Project Service
**Files:**
- Create: `/lib/services/project_service.dart`

**Requirements:**
- CRUD operations for RepairProject
- Storage service integration
- Project filtering (active/archived)
- Statistics calculation

**Commit**: `git commit -m "feat: implement project service with CRUD operations"`

---

## Phase 9: Final Integration

### Task 9.1: Wire Navigation Flow
**Files:**
- Modify: `/lib/config/routes.dart`
- Modify: `/lib/app.dart`

**Requirements:**
- All routes connected
- Initial route logic (onboarding vs EULA vs main)
- Deep link support

**Commit**: `git commit -m "feat: wire complete navigation flow"`

---

### Task 9.2: Test EULA Flow
**Files:**
- Test: `/lib/screens/eula_screen.dart`

**Requirements:**
- EULA appears on first launch
- Must scroll to bottom
- Must check checkbox
- Must tap Accept & Continue
- Accessible from Settings after acceptance

**Commit**: `git commit -m "test: verify EULA flow compliance"`

---

### Task 9.3: Test AI Chat Integration
**Files:**
- Test: `/lib/services/ai_service.dart`
- Test: `/lib/screens/main/ai_chat_screen.dart`

**Requirements:**
- Messages send to DeepSeek
- Responses display correctly
- History persists
- Error handling works

**Commit**: `git commit -m "test: verify AI chat integration"`

---

### Task 9.4: Test Photo Capture
**Files:**
- Test: `/lib/services/image_service.dart`
- Test: `/lib/screens/main/new_repair_screen.dart`

**Requirements:**
- Camera opens correctly
- Photos save locally
- Gallery selection works
- Image displays in form

**Commit**: `git commit -m "test: verify photo capture functionality"`

---

### Task 9.5: Final Polish and Accessibility
**Files:**
- All screens

**Requirements:**
- Touch targets minimum 48x48px
- Contrast ratios 4.5:1
- Scalable text
- Focus indicators
- No placeholder text

**Commit**: `git commit -m "polish: final accessibility and UI polish"`

---

## Task Summary

| Phase | Tasks | Files Created |
|-------|-------|---------------|
| Phase 1: Foundation | 5 | 15+ files |
| Phase 2: Widgets | 10 | 15+ files |
| Phase 3: Core Flow | 7 | 7 files |
| Phase 4: Main Screens | 5 | 5 files |
| Phase 5: Detail Screens | 4 | 4 files |
| Phase 6: Settings | 5 | 5 files |
| Phase 7: Additional | 1 | 1 file |
| Phase 8: Services | 3 | 3 files |
| Phase 9: Integration | 5 | N/A |
| **Total** | **45 Tasks** | **55+ Files** |

---

*This specification document serves as the single source of truth for all development. All features must be implemented as described herein.*