import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(
          colorSchemeSeed: AppColors.themecolor,
          textTheme: const TextTheme(),
          inputDecorationTheme: _inputDecorationTheme(),
          elevatedButtonTheme: _elevatedButtonThemeData()),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

ElevatedButtonThemeData _elevatedButtonThemeData() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themecolor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  );
}

InputDecorationTheme _inputDecorationTheme() {
  return InputDecorationTheme(
      fillColor: Colors.white, filled: true, border: _inputBorder());
}

OutlineInputBorder _inputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8));
}
