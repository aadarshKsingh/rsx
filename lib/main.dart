import 'package:flutter/material.dart';
import 'package:rsx/constants.dart';
import 'package:rsx/rsx.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        Constants.dark = darkColorScheme as ColorScheme;
        Constants.light = lightColorScheme as ColorScheme;
        return GetMaterialApp(
          title: 'RSX',
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            fontFamily: 'Gotham',
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          theme: ThemeData(
            fontFamily: 'Gotham',
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          home: const RSX(),
        );
      },
    );
  }
}
