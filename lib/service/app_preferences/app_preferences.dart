import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String SESSIONID = "SESSION_ID";

  saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SESSIONID, sessionId);
  }

  Future<String?> get sessionId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SESSIONID);
  }

  removeSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(SESSIONID);
  }
}
