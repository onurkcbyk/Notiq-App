import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/settings_provider.dart';
import 'screens/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Notes',
          theme: ThemeData(
            brightness: settings.brightness,
            primaryColor: settings.primaryColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: settings.primaryColor,
              brightness: settings.brightness,
            ),
            useMaterial3: true,
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: settings.textSize / 16.0,
            ),
          ),
          home: NotesHomeScreen(),
        );
      },
    );
  }
}