import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/services/app_services_impl.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_impl.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_interface.dart';
import 'package:flutter_architecture/views/details_screen.dart';
import 'package:flutter_architecture/views/film_screen.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AppServiceInterface>(AppService.instance);
  getIt.registerSingleton<FilmDetailViewModelInterface>(FilmDetailViewModel(getIt.get<AppServiceInterface>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"details": (ctx) => DetailsPage(GetIt.instance.get<FilmDetailViewModelInterface>(), filmId: 519182)},
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalization.of(context).name,
      theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}
