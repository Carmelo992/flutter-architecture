import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/screen/film_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalization.of(context).name,
      theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}
