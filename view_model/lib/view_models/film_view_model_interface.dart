import 'package:flutter/foundation.dart';
import 'package:view_model/ui_model/film_ui_model.dart';
import 'package:view_model/view_models/base_film_view_model_interface.dart';

abstract class FilmViewModelInterface extends BaseFilmViewModelInterface {
  ValueListenable<List<FilmUiModel>?> get films;
}
