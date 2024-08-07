import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/services/image_services.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';

class FilmViewModel extends BaseFilmViewModel implements FilmViewModelInterface {
  final AppServiceInterface appService;
  final ImageServiceInterface _imageService;

  FilmViewModel(this.appService, ImageServiceInterface imageService) : _imageService = imageService {
    appService.loadFilms().then((films) {
      _films.value = films;
    });
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
  ValueListenable<List<Film>?> get films => _films;
  final ValueNotifier<List<Film>?> _films = ValueNotifier(null);

  @override
  ValueListenable<List<Genre>?> get genres => _genres;
  final ValueNotifier<List<Genre>?> _genres = ValueNotifier(null);

  @override
  ValueListenable<ConfigurationImage?> get imgConfig => _imgConfig;
  final ValueNotifier<ConfigurationImage?> _imgConfig = ValueNotifier(null);
}
