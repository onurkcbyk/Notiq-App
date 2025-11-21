import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Brightness _brightness = WidgetsBinding.instance.window.platformBrightness;
  double _textSize = 18.0;
  Color _primaryColor = Colors.blue;

  Brightness get brightness => _brightness;
  double get textSize => _textSize;
  Color get primaryColor => _primaryColor;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    double? size = prefs.getDouble('textSize');
    int? colorValue = prefs.getInt('primaryColor');

    if (theme != null) {
      _brightness = theme == 'light'
          ? Brightness.light
          : theme == 'dark'
          ? Brightness.dark
          : WidgetsBinding.instance.window.platformBrightness;
    }

    if (size != null) _textSize = size;
    if (colorValue != null) _primaryColor = Color(colorValue);

    notifyListeners();
  }

  Future<void> updateTheme(Brightness brightness) async {
    _brightness = brightness;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', brightness == Brightness.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> updateTextSize(double size) async {
    _textSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', size);
    notifyListeners();
  }

  Future<void> updatePrimaryColor(Color color) async {
    _primaryColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', color.value);
    notifyListeners();
  }

}