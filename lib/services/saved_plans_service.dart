import '../models/camp_model.dart';

/// Service for managing saved camping plans
class SavedPlansService {
  static final SavedPlansService _instance = SavedPlansService._internal();
  factory SavedPlansService() => _instance;
  SavedPlansService._internal();

  final List<CampPlan> _savedPlans = [];

  /// Get all saved plans
  List<CampPlan> getSavedPlans() {
    return List.unmodifiable(_savedPlans);
  }

  /// Save a plan
  bool savePlan(CampPlan plan) {
    // Check if plan already exists
    if (_savedPlans.any((p) => p.id == plan.id)) {
      return false; // Already saved
    }
    _savedPlans.insert(0, plan);
    return true;
  }

  /// Remove a saved plan
  bool removePlan(String planId) {
    final index = _savedPlans.indexWhere((p) => p.id == planId);
    if (index != -1) {
      _savedPlans.removeAt(index);
      return true;
    }
    return false;
  }

  /// Check if a plan is saved
  bool isPlanSaved(String planId) {
    return _savedPlans.any((p) => p.id == planId);
  }

  /// Get saved plan count
  int getSavedPlanCount() {
    return _savedPlans.length;
  }

  /// Clear all saved plans
  void clearAllPlans() {
    _savedPlans.clear();
  }
}
