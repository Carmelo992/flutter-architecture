import 'package:model/data_model/film_response_model.dart';
import 'package:model/data_model/genre_response_model.dart';
import 'package:model/data_model/related_film_response_model.dart';
import 'package:model/model.dart';

import '../fake_model/configuration_result_model.dart';
import '../fake_model/film_details_result_model.dart';
import '../fake_model/genre_result_model.dart';
import '../fake_model/list_film_result_model.dart';
import '../fake_model/related_film_result_model.dart';
import '../fake_raw_data/fake_configuration_response.dart';
import '../fake_raw_data/fake_film_response.dart';
import '../fake_raw_data/fake_genre_response.dart';
import '../fake_raw_data/fake_related_film_response.dart';

class FakeAppService implements AppServiceInterface {
  final Map<int, FilmModel> _cachedFilm = {};
  List<GenreModel>? _genres;
  ConfigurationImage? _configuration;

  FakeAppService();

  @override
  Future<ListFilmResponseInterface> loadFilms() {
    return Future.delayed(const Duration(seconds: 1), () {
      var filmResponseModel = FilmResponseModel.fromJson(filmResponse);

      var films = filmResponseModel.films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return ListFilmResponse.success(films);
    });
  }

  @override
  Future<GenreResponseInterface> loadGenres() async {
    if (_genres != null) return GenreResponse.success(_genres!);
    await Future.delayed(const Duration(seconds: 2));
    var genreResponseModel = GenreResponseModel.fromJson(genreResponse);
    _genres = genreResponseModel.genres;
    return GenreResponse.success(_genres!);
  }

  @override
  Future<ConfigurationResponseInterface> loadImageConfiguration() async {
    if (_configuration != null) return ConfigurationResponse.success(_configuration!);
    await Future.delayed(const Duration(seconds: 1));
    var configImageResponse = ConfigurationModel.fromJson(configurationResponse);
    _configuration = configImageResponse.images;
    return ConfigurationResponse.success(_configuration!);
  }

  final Map<int, Future<RelatedFilmResponseInterface>> _cachedRelatedFilms = {};

  @override
  Future<RelatedFilmResponseInterface> loadRelatedFilms(int filmId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _cachedRelatedFilms.putIfAbsent(filmId, () async {
      var relatedFilmResponseModel = RelatedFilmResponseModel.fromJson(relatedFilmResponse);

      var films = relatedFilmResponseModel.films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return RelatedFilmResponse.success(films);
    });
  }

  @override
  Future<FilmDetailsResponseInterface> loadFilm(int filmId) async {
    await loadFilms();
    return FilmDetailsResponse.success(_cachedFilm[filmId]!);
  }
}
