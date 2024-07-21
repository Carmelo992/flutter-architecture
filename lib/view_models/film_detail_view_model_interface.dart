import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_impl.dart';

abstract class FilmDetailViewModelInterface extends BaseFilmViewModelInterface {
  static FilmDetailViewModel get instance => FilmDetailViewModel.instance;

  void loadFilm(int filmId);

  ValueListenable<Film?> get film;
  ValueListenable<List<Film>?> get relatedFilms;
}
