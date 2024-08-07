import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/ui_model/film_ui_model.dart';
import 'package:flutter_architecture/ui_model/genre_ui_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';
import 'package:model/model.dart';

class FilmViewModel extends BaseFilmViewModel implements FilmViewModelInterface {
  final AppServiceInterface appService;
  final ImageServiceInterface _imageService;

  FilmViewModel(this.appService, ImageServiceInterface imageService) : _imageService = imageService {
    appService.loadImageConfiguration().then((imgConfig) {
      appService.loadFilms().then((films) {
        _films.value = films?.map((model) => FilmUiModel.fromModel(model, imgConfig)).toList();
      });
      appService.loadGenres().then((genres) {
        _genres.value = genres?.map((model) => GenreUIModel.fromModel(model)).toList();
      });
    });
  }

  @override
  ImageServiceInterface get imageService => _imageService;

  @override
  ValueListenable<List<FilmUiModel>?> get films => _films;
  final ValueNotifier<List<FilmUiModel>?> _films = ValueNotifier(null);

  @override
  ValueListenable<List<GenreUIModel>?> get genres => _genres;
  final ValueNotifier<List<GenreUIModel>?> _genres = ValueNotifier(null);
}
