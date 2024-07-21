import 'package:dio/dio.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/film_response_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/model/genre_response_model.dart';
import 'package:flutter_architecture/model/related_film_response_model.dart';
import 'package:flutter_architecture/services/app_services.dart';

class AppService implements AppServiceInterface {
  static AppService? _instance;

  static AppService get instance {
    _instance ??= AppService._();
    return _instance!;
  }

  late Dio client;

  AppService._() {
    client = Dio(
      BaseOptions(
        baseUrl: "https://api.themoviedb.org/3/",
        queryParameters: {"api_key": "213c1a1d1f356ed0bf10c9656ab5d5cb"},
      ),
    );
  }

  Map<int, Film> _cachedFilm = {};

  @override
  Future<List<Film>?> loadFilms() async {
    var response =
        await client.get<Map<String, dynamic>>("movie/popular", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      var films = FilmResponse.fromJson(response.data!).films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return films;
    }
    return null;
  }

  List<Genre>? _genres;

  @override
  Future<List<Genre>?> loadGenres() async {
    if (_genres != null) return _genres!;
    var response =
        await client.get<Map<String, dynamic>>("genre/movie/list", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      _genres = GenreResponse.fromJson(response.data!).genres;
    }
    return _genres;
  }

  ConfigurationImage? _configuration;

  @override
  Future<ConfigurationImage?> loadImageConfiguration() async {
    if (_configuration != null) return _configuration!;

    var response = await client.get<Map<String, dynamic>>("configuration");
    if (response.data != null) {
      _configuration = Configuration.fromJson(response.data!).images;
    }
    return _configuration;
  }

  final Map<int, Future<List<Film>?>> _cachedRelatedFilms = {};

  @override
  Future<List<Film>?> loadRelatedFilms(int filmId) {
    return _cachedRelatedFilms.putIfAbsent(filmId, () async {
      var response = await client
          .get<Map<String, dynamic>>("movie/$filmId/similar", queryParameters: {"language": "it-IT", "page": 1});

      if (response.data != null) {
        var films = RelatedFilmResponse.fromJson(response.data!).films;
        films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
        return films;
      }
      return null;
    });
  }

  @override
  Future<Film?> loadFilm(int filmId) async {
    return _cachedFilm[filmId];
  }
}
