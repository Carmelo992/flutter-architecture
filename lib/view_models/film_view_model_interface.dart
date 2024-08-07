import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/ui_model/film_ui_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';

abstract class FilmViewModelInterface extends BaseFilmViewModelInterface {
  ValueListenable<List<FilmUiModel>?> get films;
}
