import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';

abstract class FilmDetailViewModelInterface extends BaseFilmViewModelInterface {
  void loadFilm(int filmId);

  ValueListenable<Film?> get film;
  ValueListenable<List<Film>?> get relatedFilms;
}
