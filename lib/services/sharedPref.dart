import 'package:shared_preferences/shared_preferences.dart';

Future<String> getThemeFromSharedPref() async {
  final sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('theme') ?? 'light';
}

void setThemeinSharedPref(String val) async {
  final sharedPref = await SharedPreferences.getInstance();
  await sharedPref.setString('theme', val);
}
