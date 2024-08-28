import 'dart:typed_data';

import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:view_model/view_model.dart';

import '../fake_data/fake_backdrop_image.dart';
import '../fake_data/fake_poster_image.dart';
import '../mocked_ui_models/mocked_film_ui_model.dart';
import '../mocked_ui_models/mocked_genre_ui_model.dart';

class MockedFilmViewModel implements FilmViewModelInterface {
  @override
  Uint8List? cachedImage(String path) {
    if (path.contains("stKGOm8UyhuLPR9sZLjs5AkmncA")) {
      return backdropImage;
    }
    if (path.contains("hsyNR14TSGklwoHFjPZnPiu6UlV")) {
      return posterImage;
    }
    return null;
  }

  @override
  ValueListenable<List<FilmUiModel>?> get films => _films;
  final ValueNotifier<List<FilmUiModel>?> _films = ValueNotifier(List.generate(10, (index) => MockedFilmUiModel()));

  @override
  ValueListenable<List<GenreUIModel>?> get genres => _genres;
  final ValueNotifier<List<GenreUIModel>?> _genres = ValueNotifier([MockedGenreUiModel()]);
}
