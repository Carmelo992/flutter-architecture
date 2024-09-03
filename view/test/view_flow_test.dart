import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:view/view.dart';
import 'package:view/widgets/backdrop_widget.dart';
import 'package:view/widgets/details_film_header.dart';
import 'package:view/widgets/film_card.dart';
import 'package:view/widgets/poster_widget.dart';
import 'package:view_model/view_model.dart';

import 'mocked_view_models/mocked_film_details_view_model.dart';
import 'mocked_view_models/mocked_film_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Testing film flow", () {
    testWidgets("FilmPage", (tester) async {
      FilmViewModel filmVm = MockedFilmViewModel();
      await tester.pumpWidget(MaterialApp(
        supportedLocales: AppLocalization.supportedLocales,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: FilmPage(vm: filmVm, openDetail: null),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(FilmPage), findsOneWidget, reason: "Unable to find FilmPage");
      var filmCard = find.byType(FilmCard);
      expect(filmCard, findsWidgets, reason: "Unable to find FilmCard widgets");
    });

    testWidgets("FilmDetailsPage", (tester) async {
      FilmDetailViewModel filmDetailsVm = MockedFilmDetailsViewModel();
      await tester.pumpWidget(MaterialApp(
        supportedLocales: AppLocalization.supportedLocales,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: DetailsPage(filmDetailsVm, filmId: 1, openDetail: null),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DetailsPage), findsOneWidget, reason: "Unable to find DetailsPage");
      expect(find.byType(FilmPage), findsNothing);
      expect(find.byType(DetailsHeader), findsOne);
      expect(find.byType(PosterWidget), findsWidgets);
      expect(find.byType(BackdropWidget), findsOne);
    });
  });
}
