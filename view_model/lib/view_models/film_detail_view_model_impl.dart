import 'package:flutter/foundation.dart';
import 'package:model/model.dart';
import 'package:view_model/ui_model/film_ui_model.dart';
import 'package:view_model/ui_model/genre_ui_model.dart';
import 'package:view_model/view_models/base_film_view_model.dart';
import 'package:view_model/view_models/film_detail_view_model.dart';

class FilmDetailViewModelImpl extends BaseImageFilmViewModel implements FilmDetailViewModel {
  final AppService appService;
  final ImageService _imageService;

  FilmDetailViewModelImpl(this.appService, ImageService imageService) : _imageService = imageService {
    appService.loadGenres().then((genres) {
      _genres.value = genres.responseValue?.map((model) => GenreUIModel.fromModel(model)).toList();
    });
  }

  @override
  ImageService get imageService => _imageService;

  @override
  void loadFilm(int filmId) {
    appService.loadImageConfiguration().then((imgConfig) {
      var configurationImage = imgConfig.responseValue;
      appService.loadFilm(filmId).then((film) {
        _film.value =
            film.responseValue != null ? FilmUiModel.fromModel(film.responseValue!, configurationImage) : null;
      });
      appService.loadRelatedFilms(filmId).then((films) {
        _relatedFilms.value =
            films.responseValue?.map((model) => FilmUiModel.fromModel(model, configurationImage)).toList();
      });
    });
  }

  @override
  ValueListenable<FilmUiModel?> get film => _film;
  final ValueNotifier<FilmUiModel?> _film = ValueNotifier(null);

  @override
  ValueListenable<List<FilmUiModel>?> get relatedFilms => _relatedFilms;
  final ValueNotifier<List<FilmUiModel>?> _relatedFilms = ValueNotifier(null);

  @override
  ValueListenable<List<GenreUIModel>?> get genres => _genres;
  final ValueNotifier<List<GenreUIModel>?> _genres = ValueNotifier(null);
}
