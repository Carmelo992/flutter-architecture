import 'package:flutter/foundation.dart';
import 'package:view_model/ui_model/film_ui_model.dart';
import 'package:view_model/view_models/base_film_view_model.dart';

abstract class FilmDetailViewModel extends BaseFilmViewModel {
  void loadFilm(int filmId);

  ValueListenable<FilmUiModel?> get film;

  ValueListenable<List<FilmUiModel>?> get relatedFilms;
}
