import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/services/image_services.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_interface.dart';

class FilmDetailViewModel extends BaseFilmViewModel implements FilmDetailViewModelInterface {
  final AppServiceInterface appService;
  final ImageServiceInterface _imageService;

  FilmDetailViewModel(this.appService, ImageServiceInterface imageService) : _imageService = imageService {
    appService.loadGenres().then((genres) {
      _genres.value = genres;
    });
    appService.loadImageConfiguration().then((imgConfig) {
      _imgConfig.value = imgConfig;
    });
  }

  @override
  ImageServiceInterface get imageService => _imageService;

  @override
  void loadFilm(int filmId) {
    appService.loadFilm(filmId).then((film) {
      _film.value = film;
    });
    appService.loadRelatedFilms(filmId).then((films) {
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
