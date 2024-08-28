import 'package:dio/dio.dart';
import 'package:model/data_model/configuration_model.dart';
import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/film_response_model.dart';
import 'package:model/data_model/genre_model.dart';
import 'package:model/data_model/genre_response_model.dart';
import 'package:model/data_model/related_film_response_model.dart';
import 'package:model/services/app_services/app_services.dart';

class AppService implements AppServiceInterface {
  late Dio client;
  final Map<int, FilmModel> _cachedFilm = {};
  List<GenreModel>? _genres;
  ConfigurationImage? _configuration;

  AppService() {
    client = Dio(
      BaseOptions(
        baseUrl: "https://api.themoviedb.org/3/",
        queryParameters: {"api_key": "213c1a1d1f356ed0bf10c9656ab5d5cb"},
      ),
    );
  }

  @override
  Future<List<FilmModel>?> loadFilms() async {
    var response =
        await client.get<Map<String, dynamic>>("movie/popular", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      var films = FilmResponseModel.fromJson(response.data!).films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return films;
    }
    return null;
  }

  @override
  Future<List<GenreModel>?> loadGenres() async {
    if (_genres != null) return _genres!;
    var response =
        await client.get<Map<String, dynamic>>("genre/movie/list", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      _genres = GenreResponseModel.fromJson(response.data!).genres;
    }
    return _genres;
  }

  @override
  Future<ConfigurationImage?> loadImageConfiguration() async {
    if (_configuration != null) return _configuration!;

    var response = await client.get<Map<String, dynamic>>("configuration");
    if (response.data != null) {
      _configuration = ConfigurationModel.fromJson(response.data!).images;
    }
    return _configuration;
  }

  final Map<int, Future<List<FilmModel>?>> _cachedRelatedFilms = {};

  @override
  Future<List<FilmModel>?> loadRelatedFilms(int filmId) {
    return _cachedRelatedFilms.putIfAbsent(filmId, () async {
      var response = await client
          .get<Map<String, dynamic>>("movie/$filmId/similar", queryParameters: {"language": "it-IT", "page": 1});

      if (response.data != null) {
        var films = RelatedFilmResponseModel.fromJson(response.data!).films;
        films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
        return films;
      }
      return null;
    });
  }

  @override
  Future<FilmModel?> loadFilm(int filmId) async {
    return _cachedFilm[filmId];
  }
}
