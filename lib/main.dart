import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/router/router.dart';
import 'package:flutter_architecture/view_models/film_view_model_impl.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';

void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AppServiceInterface>(AppService());
  getIt.registerSingleton<ImageServiceInterface>(ImageService());
  getIt.registerSingleton<FilmViewModelInterface>(FilmViewModel(
    getIt.get<AppServiceInterface>(),
    getIt.get<ImageServiceInterface>(),
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: ArchitectureRouter.initialize().router,
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalization.of(context).name,
      theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
    );
  }
}
