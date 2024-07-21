import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';

abstract class BaseFilmViewModelInterface {
  ValueListenable<List<Genre>?> get genres;

  ValueListenable<ConfigurationImage?> get imgConfig;
}
