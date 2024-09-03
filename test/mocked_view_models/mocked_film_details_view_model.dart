import 'dart:typed_data';

import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:view_model/view_model.dart';

import '../fake_data/fake_poster_image.dart';
import '../mocked_ui_models/mocked_film_ui_model.dart';
import '../mocked_ui_models/mocked_genre_ui_model.dart';

class MockedFilmDetailsViewModel implements FilmDetailViewModel {
  @override
  Uint8List? cachedImage(String path) {
    return posterImage;
  }

  @override
  ValueListenable<List<GenreUIModel>?> get genres => _genres;
  final ValueNotifier<List<GenreUIModel>?> _genres = ValueNotifier([MockedGenreUiModel()]);

  @override
  ValueListenable<FilmUiModel?> get film => _film;
  final ValueNotifier<FilmUiModel?> _film = ValueNotifier(null);

  @override
  ValueListenable<List<FilmUiModel>?> get relatedFilms => _relatedFilms;
  final ValueNotifier<List<FilmUiModel>?> _relatedFilms =
      ValueNotifier(List.generate(5, (index) => MockedFilmUiModel()));

  @override
  void loadFilm(int filmId) {
    Future.delayed(Duration.zero, () {
      _film.value = MockedFilmUiModel();
    });
  }
}
