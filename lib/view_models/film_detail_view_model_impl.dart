import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_interface.dart';

class FilmDetailViewModel implements FilmDetailViewModelInterface {
  static FilmDetailViewModel? _instance;

  static FilmDetailViewModel get instance {
    _instance ??= FilmDetailViewModel._();
    return _instance!;
  }

  FilmDetailViewModel._() {
    AppServiceInterface.instance.loadGenres().then((genres) {
      _genres.value = genres;
    });
    AppServiceInterface.instance.loadImageConfiguration().then((imgConfig) {
      _imgConfig.value = imgConfig;
    });
  }

  @override
  void loadFilm(int filmId) {
    AppServiceInterface.instance.loadFilm(filmId).then((film) {
      _film.value = film;
    });
    AppServiceInterface.instance.loadRelatedFilms(filmId).then((films) {
      _relatedFilms.value = films;
    });
  }

  @override
  ValueListenable<Film?> get film => _film;
  final ValueNotifier<Film?> _film = ValueNotifier(null);

  @override
  ValueListenable<List<Film>?> get relatedFilms => _relatedFilms;
  final ValueNotifier<List<Film>?> _relatedFilms = ValueNotifier(null);

  @override
  ValueListenable<List<Genre>?> get genres => _genres;
  final ValueNotifier<List<Genre>?> _genres = ValueNotifier(null);

  @override
  ValueListenable<ConfigurationImage?> get imgConfig => _imgConfig;
  final ValueNotifier<ConfigurationImage?> _imgConfig = ValueNotifier(null);
}
