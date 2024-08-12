import 'package:model/data_model/configuration_model.dart';
import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/film_response_model.dart';
import 'package:model/data_model/genre_model.dart';
import 'package:model/data_model/genre_response_model.dart';
import 'package:model/data_model/related_film_response_model.dart';
import 'package:model/services/app_services/app_services.dart';

import '../fake_models/fake_configuration_response.dart';
import '../fake_models/fake_film_response.dart';
import '../fake_models/fake_genre_response.dart';
import '../fake_models/fake_related_film_response.dart';

class FakeAppService implements AppServiceInterface {
  final Map<int, FilmModel> _cachedFilm = {};
  List<GenreModel>? _genres;
  ConfigurationImage? _configuration;

  FakeAppService();

  @override
  Future<List<FilmModel>?> loadFilms() {
    return Future.delayed(const Duration(seconds: 1), () {
      var filmResponseModel = FilmResponseModel.fromJson(filmResponse);

      var films = filmResponseModel.films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return films;
    });
  }

  @override
  Future<List<GenreModel>?> loadGenres() async {
    print("**** $_genres");
    if (_genres != null) return _genres!;
    await Future.delayed(const Duration(seconds: 2));
    var genreResponseModel = GenreResponseModel.fromJson(genreResponse);
    _genres = genreResponseModel.genres;
    return _genres;
  }

  @override
  Future<ConfigurationImage?> loadImageConfiguration() async {
    if (_configuration != null) return _configuration!;
    await Future.delayed(const Duration(seconds: 1));
    var configImageResponse = ConfigurationModel.fromJson(configurationResponse);
    _configuration = configImageResponse.images;
    return _configuration;
  }

  final Map<int, Future<List<FilmModel>?>> _cachedRelatedFilms = {};

  @override
  Future<List<FilmModel>?> loadRelatedFilms(int filmId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _cachedRelatedFilms.putIfAbsent(filmId, () async {
      var relatedFilmResponseModel = RelatedFilmResponseModel.fromJson(relatedFilmResponse);

      var films = relatedFilmResponseModel.films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return films;
    });
  }

  @override
  Future<FilmModel?> loadFilm(int filmId) async {
    await loadFilms();
    return _cachedFilm[filmId];
  }
}
