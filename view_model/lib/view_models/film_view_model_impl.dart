import 'package:flutter/foundation.dart';
import 'package:model/model.dart';
import 'package:view_model/ui_model/film_ui_model.dart';
import 'package:view_model/ui_model/genre_ui_model.dart';
import 'package:view_model/view_models/base_film_view_model.dart';
import 'package:view_model/view_models/film_view_model.dart';

class FilmViewModelImpl extends BaseImageFilmViewModel implements FilmViewModel {
  final AppService appService;
  final ImageService _imageService;

  FilmViewModelImpl(this.appService, ImageService imageService) : _imageService = imageService {
    appService.loadImageConfiguration().then((imgConfig) {
      appService.loadFilms().then((films) {
        _films.value =
            films.responseValue?.map((model) => FilmUiModel.fromModel(model, imgConfig.responseValue)).toList();
      });
      appService.loadGenres().then((genres) {
        _genres.value = genres.responseValue?.map((model) => GenreUIModel.fromModel(model)).toList();
      });
    });
  }

  @override
  ImageService get imageService => _imageService;

  @override
  ValueListenable<List<FilmUiModel>?> get films => _films;
  final ValueNotifier<List<FilmUiModel>?> _films = ValueNotifier(null);

  @override
  ValueListenable<List<GenreUIModel>?> get genres => _genres;
  final ValueNotifier<List<GenreUIModel>?> _genres = ValueNotifier(null);
}
