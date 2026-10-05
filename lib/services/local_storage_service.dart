import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/note_model.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Onboarding
  static bool isOnboardingCompleted() {
    return _prefs?.getBool(AppConstants.prefOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    await _prefs?.setBool(AppConstants.prefOnboardingCompleted, value);
  }

  // Authentication
  static bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.prefIsLoggedIn) ?? true; // default true for demo
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(AppConstants.prefIsLoggedIn, value);
  }

  // Dark Mode
  static bool isDarkMode() {
    return _prefs?.getBool(AppConstants.prefIsDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(AppConstants.prefIsDarkMode, value);
  }

  // Bookmarks
  static List<String> getBookmarks() {
    return _prefs?.getStringList(AppConstants.prefBookmarks) ?? ['ca_01', 'ca_03', 'ca_06', 'c_01', 'lc_01', 'n_01'];
  }

  static Future<void> setBookmarks(List<String> bookmarks) async {
    await _prefs?.setStringList(AppConstants.prefBookmarks, bookmarks);
  }

  // Notes
  static List<NoteModel> getNotes() {
    final rawList = _prefs?.getStringList(AppConstants.prefNotes);
    if (rawList == null || rawList.isEmpty) return [];
    try {
      return rawList.map((item) => NoteModel.fromJson(jsonDecode(item))).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveNotes(List<NoteModel> notes) async {
    final rawList = notes.map((n) => jsonEncode(n.toJson())).toList();
    await _prefs?.setStringList(AppConstants.prefNotes, rawList);
  }
}
