import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider extends ChangeNotifier {
  bool _mode = false;

  bool get mode => _mode;

  set mode(bool value) {
    _mode = value;
    notifyListeners();
  }

  Future<bool> initPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _mode = prefs.getBool("mode") ?? true;
      return true;
    } catch (e) {
      return false;
    }
  }
}
