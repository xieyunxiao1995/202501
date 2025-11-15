import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workflow.dart';
import '../models/marquee.dart';
import '../models/combo.dart';

class StorageService {
  static const String _workflowsKey = 'workflows';
  static const String _marqueesKey = 'marquees';
  static const String _combosKey = 'combos';

  // Workflows
  static Future<List<Workflow>> loadWorkflows() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_workflowsKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => Workflow.fromJson(json)).toList();
  }

  static Future<void> saveWorkflows(List<Workflow> workflows) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(workflows.map((w) => w.toJson()).toList());
    await prefs.setString(_workflowsKey, data);
  }

  // Marquees
  static Future<List<MarqueeConfig>> loadMarquees() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_marqueesKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => MarqueeConfig.fromJson(json)).toList();
  }

  static Future<void> saveMarquees(List<MarqueeConfig> marquees) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(marquees.map((m) => m.toJson()).toList());
    await prefs.setString(_marqueesKey, data);
  }

  // Combos
  static Future<List<Combo>> loadCombos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_combosKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => Combo.fromJson(json)).toList();
  }

  static Future<void> saveCombos(List<Combo> combos) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(combos.map((c) => c.toJson()).toList());
    await prefs.setString(_combosKey, data);
  }
}
