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
      final updatedRecommendations = [
        ...project.aiRecommendations,
        recommendation
      ];
      final updatedProject = project.copyWith(
        aiRecommendations: updatedRecommendations,
        updatedAt: DateTime.now(),
      );
      await updateProject(updatedProject);

      return recommendation;
    } catch (e) {
      throw ProjectServiceException(
          'Failed to get technique recommendation: $e');
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
        final currentCount =
            await _storageService.getTotalProjectsCompleted();
        await _storageService
            .setTotalProjectsCompleted(currentCount + 1);
      }
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final projects = await getAllProjects();
    final activeProjects = projects.where((p) => !p.isArchived).toList();
    final completedProjects =
        projects.where((p) => p.techniqueProgress >= 100).toList();
    final inProgressProjects =
        activeProjects.where((p) => p.techniqueProgress < 100).toList();

    // Calculate damage type distribution
    final Map<String, int> damageTypeCounts = {};
    for (final project in projects) {
      damageTypeCounts[project.damageType] =
          (damageTypeCounts[project.damageType] ?? 0) + 1;
    }

    // Calculate material distribution
    final Map<String, int> materialCounts = {};
    for (final project in projects) {
      materialCounts[project.material] =
          (materialCounts[project.material] ?? 0) + 1;
    }

    // Calculate aesthetic distribution
    final Map<String, int> aestheticCounts = {};
    for (final project in projects) {
      aestheticCounts[project.aesthetic] =
          (aestheticCounts[project.aesthetic] ?? 0) + 1;
    }

    // Calculate average progress
    final averageProgress = activeProjects.isEmpty
        ? 0.0
        : activeProjects
                .map((p) => p.techniqueProgress)
                .reduce((a, b) => a + b) /
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