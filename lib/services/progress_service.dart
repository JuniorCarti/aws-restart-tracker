import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _progressKey = 'aws_restart_progress';

  static Future<Map<int, bool>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? progressJson = prefs.getString(_progressKey);
    
    if (progressJson == null) {
      return {};
    }
    
    try {
      final Map<String, dynamic> progressMap = Map<String, dynamic>.from(
        json.decode(progressJson)
      );
      return progressMap.map((key, value) => 
        MapEntry(int.parse(key), value as bool));
    } catch (e) {
      return {};
    }
  }

  static Future<void> saveProgress(Map<int, bool> progress) async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = json.encode(
      progress.map((key, value) => MapEntry(key.toString(), value))
    );
    await prefs.setString(_progressKey, progressJson);
  }

  static Future<void> toggleModuleProgress(int moduleId, bool completed) async {
    final progress = await getProgress();
    progress[moduleId] = completed;
    await saveProgress(progress);
  }

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}