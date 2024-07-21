import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_view_model_impl.dart';

abstract class FilmViewModelInterface extends BaseFilmViewModelInterface {
  static FilmViewModel get instance => FilmViewModel.instance;

  ValueListenable<List<Film>?> get films;
}
