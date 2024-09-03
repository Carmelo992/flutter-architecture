import 'package:flutter/material.dart';
import 'package:flutter_architecture/router/router.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:view/view.dart';
import 'package:view_model/view_model.dart';

void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AppService>(AppServiceImpl());
  getIt.registerSingleton<ImageService>(ImageServiceImpl());
  getIt.registerSingleton<FilmViewModel>(FilmViewModelImpl(
    getIt.get<AppService>(),
    getIt.get<ImageService>(),
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: ArchitectureRouter.initialize(
        getVm: <T extends Object>() => GetIt.instance.get<T>(),
        pushScope: <T extends Object>(name) {
          if (!GetIt.instance.hasScope(name)) {
            if (T == FilmDetailViewModel) {
              GetIt.instance.pushNewScope(
                init: (getIt) {
                  getIt.registerSingleton<FilmDetailViewModel>(FilmDetailViewModelImpl(
                    getIt.get<AppService>(),
                    getIt.get<ImageService>(),
                  ));
                },
                scopeName: name,
              );
              return;
            }
            throw "PushScope not defined for type $T";
          }
        },
        popScope: (String name) {
          if (GetIt.instance.hasScope(name)) {
            GetIt.instance.dropScope(name);
          }
        },
      ).router,
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalization.of(context).name,
      theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
    );
  }
}
