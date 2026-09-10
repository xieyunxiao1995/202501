# CP嗒啧 Core Logic Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the complete core logic layer for CP嗒啧 app - including data models, storage service, AI service, image service, and project service.

**Architecture:** Services-layer architecture with clean separation. All business logic, API calls, and local storage isolated in `lib/services/` and `lib/models/`. No logic in UI code.

**Tech Stack:** Flutter, SharedPreferences, http package, image_picker, DeepSeek API

---

## Task 1: Create Flutter Project Structure

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/pubspec.yaml`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/main.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/app.dart`

**Step 1: Create pubspec.yaml with dependencies**

```yaml
name: CP嗒啧
description: A Kintsugi artisan companion app.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  http: ^1.1.0
  image_picker: ^1.0.4
  path_provider: ^2.1.1
  uuid: ^4.1.0

flutter:
  uses-material-design: true
```

**Step 2: Create main.dart entry point**

```dart
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

**Step 3: Create app.dart**

```dart
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'theme/app_colors.dart';
import 'config/routes.dart';

class OrclavitasynApp extends StatelessWidget {
  final StorageService storageService;

  const OrclavitasynApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CP嗒啧',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: false,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

**Commit:** `feat: initialize Flutter project structure`

---

## Task 2: Create Data Models

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/models/repair_project.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/models/chat_message.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/models/user_preferences.dart`

**Step 1: Create RepairProject model**

```dart
import 'dart:convert';

class RepairProject {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> photoPaths;
  final String damageType;
  final String material;
  final String aesthetic;
  final String crackNarrative;
  final int techniqueProgress;
  final List<String> aiRecommendations;
  final bool isArchived;

  const RepairProject({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'photoPaths': photoPaths,
      'damageType': damageType,
      'material': material,
      'aesthetic': aesthetic,
      'crackNarrative': crackNarrative,
      'techniqueProgress': techniqueProgress,
      'aiRecommendations': aiRecommendations,
      'isArchived': isArchived,
    };
  }

  factory RepairProject.fromJson(Map<String, dynamic> json) {
    return RepairProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      photoPaths: (json['photoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      damageType: json['damageType'] as String? ?? 'crack',
      material: json['material'] as String? ?? 'stoneware',
      aesthetic: json['aesthetic'] as String? ?? 'classic-gold',
      crackNarrative: json['crackNarrative'] as String? ?? '',
      techniqueProgress: json['techniqueProgress'] as int? ?? 0,
      aiRecommendations: (json['aiRecommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static RepairProject fromJsonString(String jsonString) {
    return RepairProject.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  RepairProject copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? photoPaths,
    String? damageType,
    String? material,
    String? aesthetic,
    String? crackNarrative,
    int? techniqueProgress,
    List<String>? aiRecommendations,
    bool? isArchived,
  }) {
    return RepairProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoPaths: photoPaths ?? this.photoPaths,
      damageType: damageType ?? this.damageType,
      material: material ?? this.material,
      aesthetic: aesthetic ?? this.aesthetic,
      crackNarrative: crackNarrative ?? this.crackNarrative,
      techniqueProgress: techniqueProgress ?? this.techniqueProgress,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
```

**Step 2: Create ChatMessage model**

```dart
import 'dart:convert';

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static ChatMessage fromJsonString(String jsonString) {
    return ChatMessage.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
```

**Step 3: Create UserPreferences model**

```dart
import 'dart:convert';

class UserPreferences {
  final bool hasAcceptedEula;
  final bool hasCompletedOnboarding;
  final String preferredAesthetic;
  final int totalProjectsCompleted;

  const UserPreferences({
    this.hasAcceptedEula = false,
    this.hasCompletedOnboarding = false,
    this.preferredAesthetic = 'classic-gold',
    this.totalProjectsCompleted = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'hasAcceptedEula': hasAcceptedEula,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'preferredAesthetic': preferredAesthetic,
      'totalProjectsCompleted': totalProjectsCompleted,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      hasAcceptedEula: json['hasAcceptedEula'] as bool? ?? false,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      preferredAesthetic: json['preferredAesthetic'] as String? ?? 'classic-gold',
      totalProjectsCompleted: json['totalProjectsCompleted'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static UserPreferences fromJsonString(String jsonString) {
    return UserPreferences.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  UserPreferences copyWith({
    bool? hasAcceptedEula,
    bool? hasCompletedOnboarding,
    String? preferredAesthetic,
    int? totalProjectsCompleted,
  }) {
    return UserPreferences(
      hasAcceptedEula: hasAcceptedEula ?? this.hasAcceptedEula,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      preferredAesthetic: preferredAesthetic ?? this.preferredAesthetic,
      totalProjectsCompleted: totalProjectsCompleted ?? this.totalProjectsCompleted,
    );
  }
}
```

**Commit:** `feat: implement data models with JSON serialization`

---

## Task 3: Create Storage Service

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/services/storage_service.dart`

**Step 1: Implement StorageService with all SharedPreferences methods**

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/repair_project.dart';
import '../models/chat_message.dart';
import '../models/user_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  // Storage Keys
  static const String _keyEulaAccepted = 'pref_eula_accepted';
  static const String _keyOnboardingCompleted = 'pref_onboarding_completed';
  static const String _keyFirstLaunch = 'pref_is_first_launch';
  static const String _keyPreferredAesthetic = 'pref_preferred_aesthetic';
  static const String _keyTotalProjectsCompleted = 'pref_total_projects_completed';
  static const String _keyLastChatTimestamp = 'pref_last_chat_timestamp';
  static const String _keyRepairProjects = 'data_repair_projects';
  static const String _keyChatHistory = 'data_chat_history';
  static const String _keyUserPreferences = 'data_user_preferences';
  static const String _keyLastPhotoPath = 'cache_last_photo_path';
  static const String _keyTempProjectId = 'cache_temp_project_id';

  StorageService(this._prefs);

  // EULA & Onboarding
  Future<bool> hasAcceptedEula() async {
    try {
      return _prefs.getBool(_keyEulaAccepted) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setEulaAccepted(bool value) async {
    try {
      await _prefs.setBool(_keyEulaAccepted, value);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<bool> hasCompletedOnboarding() async {
    try {
      return _prefs.getBool(_keyOnboardingCompleted) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setOnboardingCompleted(bool value) async {
    try {
      await _prefs.setBool(_keyOnboardingCompleted, value);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<bool> isFirstLaunch() async {
    try {
      return _prefs.getBool(_keyFirstLaunch) ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<void> setFirstLaunch(bool value) async {
    try {
      await _prefs.setBool(_keyFirstLaunch, value);
    } catch (e) {
      // Handle error silently
    }
  }

  // User Preferences
  Future<String> getPreferredAesthetic() async {
    try {
      return _prefs.getString(_keyPreferredAesthetic) ?? 'classic-gold';
    } catch (e) {
      return 'classic-gold';
    }
  }

  Future<void> setPreferredAesthetic(String aesthetic) async {
    try {
      await _prefs.setString(_keyPreferredAesthetic, aesthetic);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<int> getTotalProjectsCompleted() async {
    try {
      return _prefs.getInt(_keyTotalProjectsCompleted) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> incrementProjectsCompleted() async {
    try {
      final current = await getTotalProjectsCompleted();
      await _prefs.setInt(_keyTotalProjectsCompleted, current + 1);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setTotalProjectsCompleted(int value) async {
    try {
      await _prefs.setInt(_keyTotalProjectsCompleted, value);
    } catch (e) {
      // Handle error silently
    }
  }

  // Repair Projects
  Future<List<RepairProject>> getAllProjects() async {
    try {
      final jsonString = _prefs.getString(_keyRepairProjects) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => RepairProject.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveProject(RepairProject project) async {
    try {
      final projects = await getAllProjects();
      final existingIndex = projects.indexWhere((p) => p.id == project.id);

      if (existingIndex >= 0) {
        projects[existingIndex] = project;
      } else {
        projects.add(project);
      }

      final jsonList = projects.map((p) => p.toJson()).toList();
      await _prefs.setString(_keyRepairProjects, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      final projects = await getAllProjects();
      projects.removeWhere((p) => p.id == projectId);
      final jsonList = projects.map((p) => p.toJson()).toList();
      await _prefs.setString(_keyRepairProjects, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> archiveProject(String projectId) async {
    try {
      final projects = await getAllProjects();
      final index = projects.indexWhere((p) => p.id == projectId);
      if (index >= 0) {
        projects[index] = projects[index].copyWith(isArchived: true);
        final jsonList = projects.map((p) => p.toJson()).toList();
        await _prefs.setString(_keyRepairProjects, jsonEncode(jsonList));
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<RepairProject?> getProjectById(String id) async {
    try {
      final projects = await getAllProjects();
      return projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Chat History
  Future<List<ChatMessage>> getChatHistory() async {
    try {
      final jsonString = _prefs.getString(_keyChatHistory) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addChatMessage(ChatMessage message) async {
    try {
      final history = await getChatHistory();
      history.add(message);
      final jsonList = history.map((m) => m.toJson()).toList();
      await _prefs.setString(_keyChatHistory, jsonEncode(jsonList));
      await _prefs.setString(_keyLastChatTimestamp, message.timestamp.toIso8601String());
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearChatHistory() async {
    try {
      await _prefs.setString(_keyChatHistory, '[]');
      await _prefs.setString(_keyLastChatTimestamp, '');
    } catch (e) {
      // Handle error silently
    }
  }

  Future<String> getLastChatTimestamp() async {
    try {
      return _prefs.getString(_keyLastChatTimestamp) ?? '';
    } catch (e) {
      return '';
    }
  }

  // Cache
  Future<String> getLastPhotoPath() async {
    try {
      return _prefs.getString(_keyLastPhotoPath) ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> setLastPhotoPath(String path) async {
    try {
      await _prefs.setString(_keyLastPhotoPath, path);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<String?> getTempProjectId() async {
    try {
      return _prefs.getString(_keyTempProjectId);
    } catch (e) {
      return null;
    }
  }

  Future<void> setTempProjectId(String? id) async {
    try {
      if (id == null) {
        await _prefs.remove(_keyTempProjectId);
      } else {
        await _prefs.setString(_keyTempProjectId, id);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearTempProjectId() async {
    try {
      await _prefs.remove(_keyTempProjectId);
    } catch (e) {
      // Handle error silently
    }
  }

  // User Preferences Object
  Future<UserPreferences> getUserPreferences() async {
    try {
      final jsonString = _prefs.getString(_keyUserPreferences) ?? '{}';
      return UserPreferences.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      return const UserPreferences();
    }
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      await _prefs.setString(_keyUserPreferences, preferences.toJsonString());
    } catch (e) {
      // Handle error silently
    }
  }
}
```

**Commit:** `feat: implement storage service with SharedPreferences`

---

## Task 4: Create AI Service

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/services/ai_service.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/config/app_config.dart`

**Step 1: Create AppConfig with API configuration**

```dart
class AppConfig {
  // DeepSeek API Configuration
  static const String deepSeekApiKey = 'YOUR_DEEPSEEK_API_KEY';
  static const String deepSeekEndpoint = 'https://api.deepseek.com/v1/chat/completions';
  static const String deepSeekModel = 'deepseek-chat';

  // AI Parameters
  static const double aiTemperature = 0.7;
  static const int aiMaxTokens = 500;
  static const Duration aiTimeout = Duration(seconds: 30);

  // App Info
  static const String appName = 'CP嗒啧';
  static const String appVersion = '1.0.0';
}
```

**Step 2: Create AIService with DeepSeek integration**

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/chat_message.dart';

class AIService {
  static const String _systemPrompt = '''
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
''';

  final http.Client _client;

  AIService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> sendMessage(
    String userMessage, {
    List<ChatMessage>? history,
  }) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
      ];

      // Add chat history if provided
      if (history != null && history.isNotEmpty) {
        for (final msg in history) {
          messages.add({
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.content,
          });
        }
      }

      // Add current user message
      messages.add({'role': 'user', 'content': userMessage});

      final response = await _client
          .post(
            Uri.parse(AppConfig.deepSeekEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConfig.deepSeekApiKey}',
            },
            body: jsonEncode({
              'model': AppConfig.deepSeekModel,
              'messages': messages,
              'temperature': AppConfig.aiTemperature,
              'max_tokens': AppConfig.aiMaxTokens,
            }),
          )
          .timeout(AppConfig.aiTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = responseData['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          final message = choices[0]['message'] as Map<String, dynamic>;
          return message['content'] as String;
        } else {
          throw AIServiceException('No response content received from AI');
        }
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown error';
        throw AIServiceException('API Error (${response.statusCode}): $errorMessage');
      }
    } on http.ClientException catch (e) {
      throw AIServiceException('Network error: ${e.message}');
    } catch (e) {
      if (e is AIServiceException) rethrow;
      throw AIServiceException('Failed to send message: $e');
    }
  }

  Future<String> generateCrackNarrative({
    required String damageType,
    required String material,
    required String aesthetic,
    String? description,
  }) async {
    final prompt = '''
Generate a poetic Kintsugi narrative for a repair project with the following details:

Damage Type: $damageType
Ceramic Material: $material
Aesthetic Preference: $aesthetic
${description != null ? 'Description: $description' : ''}

Please create a short, poetic narrative (2-3 sentences) that views this crack as a story waiting to be told in gold. Connect it to wabi-sabi philosophy and the beauty of imperfection.
''';

    return await sendMessage(prompt);
  }

  Future<String> getTechniqueRecommendation({
    required String damageType,
    required String material,
    String? description,
  }) async {
    final prompt = '''
Provide technique recommendations for a Kintsugi repair:

Damage Type: $damageType
Ceramic Material: $material
${description != null ? 'Description: $description' : ''}

Please provide:
1. Recommended technique
2. Required materials and tools
3. Key steps to follow
4. Common pitfalls to avoid
''';

    return await sendMessage(prompt);
  }

  void dispose() {
    _client.close();
  }
}

class AIServiceException implements Exception {
  final String message;

  AIServiceException(this.message);

  @override
  String toString() => 'AIServiceException: $message';
}
```

**Commit:** `feat: implement AI service with DeepSeek integration`

---

## Task 5: Create Image Service

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/services/image_service.dart`

**Step 1: Implement ImageService for camera and gallery**

```dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  Future<File?> captureFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return null;

      return await _saveImageToLocal(File(image.path));
    } catch (e) {
      throw ImageServiceException('Failed to capture image from camera: $e');
    }
  }

  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return null;

      return await _saveImageToLocal(File(image.path));
    } catch (e) {
      throw ImageServiceException('Failed to pick image from gallery: $e');
    }
  }

  Future<List<File>> pickMultipleFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      final List<File> savedImages = [];
      for (final image in images) {
        final saved = await _saveImageToLocal(File(image.path));
        savedImages.add(saved);
      }

      return savedImages;
    } catch (e) {
      throw ImageServiceException('Failed to pick images from gallery: $e');
    }
  }

  Future<File> _saveImageToLocal(File sourceFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'repair_${_uuid.v4()}.jpg';
      final String newPath = '${appDir.path}/$fileName';

      // Create app-specific directory if it doesn't exist
      final Directory imagesDir = Directory('${appDir.path}/repair_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final File newFile = await sourceFile.copy('${imagesDir.path}/$fileName');
      return newFile;
    } catch (e) {
      throw ImageServiceException('Failed to save image locally: $e');
    }
  }

  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      throw ImageServiceException('Failed to delete image: $e');
    }
  }

  Future<bool> imageExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAllImages() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/repair_images');

      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
      }
    } catch (e) {
      throw ImageServiceException('Failed to clear images: $e');
    }
  }
}

class ImageServiceException implements Exception {
  final String message;

  ImageServiceException(this.message);

  @override
  String toString() => 'ImageServiceException: $message';
}
```

**Commit:** `feat: implement image service for camera and gallery`

---

## Task 6: Create Project Service

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/services/project_service.dart`

**Step 1: Implement ProjectService for CRUD operations**

```dart
import '../models/repair_project.dart';
import '../services/storage_service.dart';
import '../services/ai_service.dart';

class ProjectService {
  final StorageService _storageService;
  final AIService _aiService;

  ProjectService({
    required StorageService storageService,
    AIService? aiService,
  })  : _storageService = storageService,
        _aiService = aiService ?? AIService();

  Future<List<RepairProject>> getAllProjects() async {
    return await _storageService.getAllProjects();
  }

  Future<List<RepairProject>> getActiveProjects() async {
    final projects = await _storageService.getAllProjects();
    return projects.where((p) => !p.isArchived).toList();
  }

  Future<List<RepairProject>> getArchivedProjects() async {
    final projects = await _storageService.getAllProjects();
    return projects.where((p) => p.isArchived).toList();
  }

  Future<RepairProject?> getProjectById(String id) async {
    return await _storageService.getProjectById(id);
  }

  Future<void> createProject(RepairProject project) async {
    await _storageService.saveProject(project);
  }

  Future<void> updateProject(RepairProject project) async {
    final updatedProject = project.copyWith(updatedAt: DateTime.now());
    await _storageService.saveProject(updatedProject);
  }

  Future<void> deleteProject(String projectId) async {
    await _storageService.deleteProject(projectId);
  }

  Future<void> archiveProject(String projectId) async {
    await _storageService.archiveProject(projectId);
  }

  Future<void> unarchiveProject(String projectId) async {
    final project = await getProjectById(projectId);
    if (project != null) {
      await updateProject(project.copyWith(isArchived: false));
    }
  }

  Future<String> generateNarrative(RepairProject project) async {
    try {
      final narrative = await _aiService.generateCrackNarrative(
        damageType: project.damageType,
        material: project.material,
        aesthetic: project.aesthetic,
        description: project.description,
      );

      final updatedProject = project.copyWith(
        crackNarrative: narrative,
        updatedAt: DateTime.now(),
      );
      await updateProject(updatedProject);

      return narrative;
    } catch (e) {
      throw ProjectServiceException('Failed to generate narrative: $e');
    }
  }

  Future<String> getTechniqueRecommendation(RepairProject project) async {
    try {
      final recommendation = await _aiService.getTechniqueRecommendation(
        damageType: project.damageType,
        material: project.material,
        description: project.description,
      );

      // Add recommendation to project
      final updatedRecommendations = [...project.aiRecommendations, recommendation];
      final updatedProject = project.copyWith(
        aiRecommendations: updatedRecommendations,
        updatedAt: DateTime.now(),
      );
      await updateProject(updatedProject);

      return recommendation;
    } catch (e) {
      throw ProjectServiceException('Failed to get technique recommendation: $e');
    }
  }

  Future<void> updateProgress(String projectId, int progress) async {
    final project = await getProjectById(projectId);
    if (project != null) {
      final updatedProject = project.copyWith(
        techniqueProgress: progress.clamp(0, 100),
        updatedAt: DateTime.now(),
      );
      await updateProject(updatedProject);

      // If project is completed, increment counter
      if (progress >= 100 && project.techniqueProgress < 100) {
        final currentCount = await _storageService.getTotalProjectsCompleted();
        await _storageService.setTotalProjectsCompleted(currentCount + 1);
      }
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final projects = await getAllProjects();
    final activeProjects = projects.where((p) => !p.isArchived).toList();
    final completedProjects = projects.where((p) => p.techniqueProgress >= 100).toList();
    final inProgressProjects = activeProjects.where((p) => p.techniqueProgress < 100).toList();

    // Calculate damage type distribution
    final Map<String, int> damageTypeCounts = {};
    for (final project in projects) {
      damageTypeCounts[project.damageType] = (damageTypeCounts[project.damageType] ?? 0) + 1;
    }

    // Calculate material distribution
    final Map<String, int> materialCounts = {};
    for (final project in projects) {
      materialCounts[project.material] = (materialCounts[project.material] ?? 0) + 1;
    }

    // Calculate aesthetic distribution
    final Map<String, int> aestheticCounts = {};
    for (final project in projects) {
      aestheticCounts[project.aesthetic] = (aestheticCounts[project.aesthetic] ?? 0) + 1;
    }

    // Calculate average progress
    final averageProgress = activeProjects.isEmpty
        ? 0.0
        : activeProjects.map((p) => p.techniqueProgress).reduce((a, b) => a + b) /
            activeProjects.length;

    return {
      'totalProjects': projects.length,
      'activeProjects': activeProjects.length,
      'archivedProjects': projects.where((p) => p.isArchived).length,
      'completedProjects': completedProjects.length,
      'inProgressProjects': inProgressProjects.length,
      'totalCompleted': await _storageService.getTotalProjectsCompleted(),
      'averageProgress': averageProgress,
      'damageTypeDistribution': damageTypeCounts,
      'materialDistribution': materialCounts,
      'aestheticDistribution': aestheticCounts,
    };
  }
}

class ProjectServiceException implements Exception {
  final String message;

  ProjectServiceException(this.message);

  @override
  String toString() => 'ProjectServiceException: $message';
}
```

**Commit:** `feat: implement project service with CRUD operations`

---

## Task 7: Create Theme System

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/theme/app_colors.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/theme/app_text_styles.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/theme/app_decorations.dart`

**Step 1: Create AppColors**

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFFC17F59);
  static const Color primaryLight = Color(0xFFD4A084);
  static const Color primaryDark = Color(0xFF8B5A3C);

  // Accent
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentGoldLight = Color(0xFFE5C76B);
  static const Color accentGoldDark = Color(0xFFB8962E);

  // Background & Surface
  static const Color background = Color(0xFFFDF8F4);
  static const Color surface = Color(0xFFF5EDE6);
  static const Color surfaceDark = Color(0xFFE8DED5);

  // Text
  static const Color textPrimary = Color(0xFF3D2E24);
  static const Color textSecondary = Color(0xFF7A6B5D);
  static const Color textLight = Color(0xFFA89888);

  // Status
  static const Color error = Color(0xFFC75B39);
  static const Color success = Color(0xFF6B8E4E);
  static const Color warning = Color(0xFFD4A037);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentGoldLight, accentGold, accentGoldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ceramicGradient = LinearGradient(
    colors: [surface, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

**Step 2: Create AppTextStyles**

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headlines
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.4,
  );
}
```

**Step 3: Create AppDecorations**

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  // Card Decorations
  static BoxDecoration ceramicCard({
    bool isActive = false,
    Color? customColor,
  }) {
    return BoxDecoration(
      color: customColor ?? AppColors.surface,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(12),
        bottomLeft: const Radius.circular(14),
        bottomRight: const Radius.circular(18),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryDark.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.accentGold.withOpacity(isActive ? 0.15 : 0),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Input Decorations
  static InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textLight),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // Button Decorations
  static BoxDecoration primaryButton({bool isDisabled = false}) {
    return BoxDecoration(
      gradient: isDisabled ? null : AppColors.primaryGradient,
      color: isDisabled ? AppColors.textLight : null,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(16),
        bottomLeft: const Radius.circular(14),
        bottomRight: const Radius.circular(10),
      ),
      boxShadow: isDisabled
          ? null
          : [
              BoxShadow(
                color: AppColors.primaryDark.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
    );
  }

  static BoxDecoration goldButton() {
    return BoxDecoration(
      gradient: AppColors.goldGradient,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(14),
        topRight: const Radius.circular(10),
        bottomLeft: const Radius.circular(12),
        bottomRight: const Radius.circular(16),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.accentGoldDark.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Chat Bubble Decorations
  static BoxDecoration userBubble() {
    return BoxDecoration(
      color: AppColors.primary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    );
  }

  static BoxDecoration aiBubble() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      border: Border.all(
        color: AppColors.accentGold.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  // Divider
  static BoxDecoration goldDivider() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.accentGold,
          AppColors.accentGold,
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }
}
```

**Commit:** `feat: create organic asymmetry theme system`

---

## Task 8: Create Routes Configuration

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/config/routes.dart`

**Step 1: Create routes configuration**

```dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/eula_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/detail/repair_detail_screen.dart';
import '../screens/detail/photo_fullscreen.dart';
import '../screens/detail/technique_analysis_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/user_agreement_screen.dart';
import '../screens/settings/privacy_policy_screen.dart';
import '../screens/settings/help_tutorial_screen.dart';
import '../screens/settings/feedback_screen.dart';
import '../screens/statistics_screen.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String eula = '/eula';
  static const String main = '/main';
  static const String repairDetail = '/repair-detail';
  static const String photoFullscreen = '/photo-fullscreen';
  static const String techniqueAnalysis = '/technique-analysis';
  static const String statistics = '/statistics';
  static const String about = '/about';
  static const String userAgreement = '/user-agreement';
  static const String privacyPolicy = '/privacy-policy';
  static const String helpTutorial = '/help-tutorial';
  static const String feedback = '/feedback';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    eula: (context) => const EulaScreen(),
    main: (context) => const MainScreen(),
    repairDetail: (context) => const RepairDetailScreen(),
    photoFullscreen: (context) => const PhotoFullscreenScreen(),
    techniqueAnalysis: (context) => const TechniqueAnalysisScreen(),
    statistics: (context) => const StatisticsScreen(),
    about: (context) => const AboutScreen(),
    userAgreement: (context) => const UserAgreementScreen(),
    privacyPolicy: (context) => const PrivacyPolicyScreen(),
    helpTutorial: (context) => const HelpTutorialScreen(),
    feedback: (context) => const FeedbackScreen(),
  };
}
```

**Commit:** `feat: create routes configuration`

---

## Task 9: Create Utils

**Files:**
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/utils/constants.dart`
- Create: `/Users/admin/Desktop/Flutter_app/20260314/lib/utils/formatters.dart`

**Step 1: Create constants**

```dart
class AppConstants {
  // Damage Types
  static const List<String> damageTypes = [
    'crack',
    'chip',
    'shatter',
    'multiple',
  ];

  static String getDamageTypeLabel(String type) {
    switch (type) {
      case 'crack':
        return 'Crack';
      case 'chip':
        return 'Chip';
      case 'shatter':
        return 'Shatter';
      case 'multiple':
        return 'Multiple Pieces';
      default:
        return type;
    }
  }

  // Materials
  static const List<String> materials = [
    'porcelain',
    'stoneware',
    'earthenware',
    'raku',
  ];

  static String getMaterialLabel(String material) {
    switch (material) {
      case 'porcelain':
        return 'Porcelain';
      case 'stoneware':
        return 'Stoneware';
      case 'earthenware':
        return 'Earthenware';
      case 'raku':
        return 'Raku';
      default:
        return material;
    }
  }

  // Aesthetics
  static const List<String> aesthetics = [
    'classic-gold',
    'modern-silver',
    'rustic-bronze',
    'contemporary-mix',
  ];

  static String getAestheticLabel(String aesthetic) {
    switch (aesthetic) {
      case 'classic-gold':
        return 'Classic Gold';
      case 'modern-silver':
        return 'Modern Silver';
      case 'rustic-bronze':
        return 'Rustic Bronze';
      case 'contemporary-mix':
        return 'Contemporary Mix';
      default:
        return aesthetic;
    }
  }

  // AI Preset Prompts
  static const List<String> aiPresetPrompts = [
    'How do I prepare the lacquer?',
    'What gold powder grade should I use?',
    'How long should curing take?',
    'Explain wabi-sabi philosophy',
  ];
}
```

**Step 2: Create formatters**

```dart
import 'package:intl/intl.dart';

class AppFormatters {
  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM d, yyyy h:mm a');
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  static String formatProgress(int progress) {
    return '$progress%';
  }
}
```

**Commit:** `feat: create utility classes`

---

## Task 10: Configure iOS Permissions

**Files:**
- Modify: `/Users/admin/Desktop/Flutter_app/20260314/ios/Runner/Info.plist` (after Flutter project creation)

**Step 1: Add camera and photo library permissions to Info.plist**

Add the following keys inside the `<dict>` element:

```xml
<key>NSCameraUsageDescription</key>
<string>CP嗒啧 needs access to your camera to photograph broken ceramic pieces for your repair projects.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>CP嗒啧 needs access to your photo library to select images of broken ceramic pieces for your repair projects.</string>
```

**Commit:** `feat: configure iOS camera and photo library permissions`

---

## Summary

| Task | Description | Files |
|------|-------------|-------|
| 1 | Project Structure | pubspec.yaml, main.dart, app.dart |
| 2 | Data Models | repair_project.dart, chat_message.dart, user_preferences.dart |
| 3 | Storage Service | storage_service.dart |
| 4 | AI Service | ai_service.dart, app_config.dart |
| 5 | Image Service | image_service.dart |
| 6 | Project Service | project_service.dart |
| 7 | Theme System | app_colors.dart, app_text_styles.dart, app_decorations.dart |
| 8 | Routes | routes.dart |
| 9 | Utils | constants.dart, formatters.dart |
| 10 | iOS Permissions | Info.plist |

Total: 15+ files to implement core logic layer.