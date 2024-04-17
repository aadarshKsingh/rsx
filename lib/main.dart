import 'package:flutter/material.dart';
import 'package:rsx/rsx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSX',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        fontFamily: 'Gotham',
        brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      theme: ThemeData(
        fontFamily: 'Gotham',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RSX(),
    );
  }
}
