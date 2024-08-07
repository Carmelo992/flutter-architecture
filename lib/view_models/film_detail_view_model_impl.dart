import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/ui_model/film_ui_model.dart';
import 'package:flutter_architecture/ui_model/genre_ui_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_interface.dart';
import 'package:model/model.dart';

class FilmDetailViewModel extends BaseFilmViewModel implements FilmDetailViewModelInterface {
  final AppServiceInterface appService;
  final ImageServiceInterface _imageService;

  FilmDetailViewModel(this.appService, ImageServiceInterface imageService) : _imageService = imageService {
    appService.loadGenres().then((genres) {
      _genres.value = genres?.map((model) => GenreUIModel.fromModel(model)).toList();
    });
  }

  @override
  ImageServiceInterface get imageService => _imageService;

  @override
  void loadFilm(int filmId) {
    appService.loadImageConfiguration().then((imgConfig) {
      appService.loadFilm(filmId).then((film) {
        _film.value = film != null ? FilmUiModel.fromModel(film, imgConfig) : null;
      });
      appService.loadRelatedFilms(filmId).then((films) {
        _relatedFilms.value = films?.map((model) => FilmUiModel.fromModel(model, imgConfig)).toList();
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
