import 'package:flutter/material.dart';
import 'package:flutter_architecture/router/router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:view/view.dart';
import 'package:view/widgets/film_card.dart';
import 'package:view_model/view_model.dart';

import 'mocked_view_models/mocked_film_details_view_model.dart';
import 'mocked_view_models/mocked_film_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<FilmViewModel>(MockedFilmViewModel());

  testWidgets("Testing app flow", (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
      routerConfig: ArchitectureRouter.initialize(
        getVm: <T extends Object>() => GetIt.instance.get<T>(),
        pushScope: <T extends Object>(name) {
          if (!GetIt.instance.hasScope(name)) {
            switch (T) {
              case const (FilmDetailViewModel):
                GetIt.instance.pushNewScope(
                  init: (getIt) {
                    getIt.registerSingleton<FilmDetailViewModel>(MockedFilmDetailsViewModel());
                  },
                  scopeName: name,
                );
                break;
              default:
                throw "PushScope not defined for type $T";
            }
          }
        },
        popScope: (String name) {
          if (GetIt.instance.hasScope(name)) {
            GetIt.instance.dropScope(name);
          }
        },
      ).router,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(SplashPage), findsOneWidget, reason: "Unable to find SplashPage");
    expect(find.byType(FilmPage), findsNothing, reason: "Find FilmPage instead of SplashPage");
    expect(find.byType(DetailsPage), findsNothing, reason: "Find DetailsPage instead of SplashPage");
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.byType(FilmPage), findsOneWidget, reason: "Unable to find FilmPage");
    expect(find.byType(DetailsPage), findsNothing, reason: "Find DetailsPage instead of FilmPage");
    var filmCard = find.byType(FilmCard);
    await tester.tap(filmCard.first);
    await tester.pumpAndSettle();
    expect(find.byType(DetailsPage), findsOneWidget, reason: "Unable to find DetailsPage");
    expect(find.byType(FilmPage), findsNothing, reason: "Find FilmPage instead of DetailsPage");
  });
}
