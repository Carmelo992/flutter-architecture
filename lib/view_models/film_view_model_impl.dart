import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';

class FilmViewModel implements FilmViewModelInterface {
  static FilmViewModel? _instance;

  static FilmViewModel get instance {
    _instance ??= FilmViewModel._();
    return _instance!;
  }

  FilmViewModel._() {
    AppServiceInterface.instance.loadFilms().then((films) {
      _films.value = films;
    });
    AppServiceInterface.instance.loadGenres().then((genres) {
      _genres.value = genres;
    });
    AppServiceInterface.instance.loadImageConfiguration().then((imgConfig) {
      _imgConfig.value = imgConfig;
    });
  }

  @override
  ValueListenable<List<Film>?> get films => _films;
  final ValueNotifier<List<Film>?> _films = ValueNotifier(null);

  @override
  ValueListenable<List<Genre>?> get genres => _genres;
  final ValueNotifier<List<Genre>?> _genres = ValueNotifier(null);

  @override
  ValueListenable<ConfigurationImage?> get imgConfig => _imgConfig;
  final ValueNotifier<ConfigurationImage?> _imgConfig = ValueNotifier(null);
}
