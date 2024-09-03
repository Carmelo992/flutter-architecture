import 'package:dio/dio.dart';
import 'package:model/data_model/configuration_model.dart';
import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/film_response_model.dart';
import 'package:model/data_model/genre_model.dart';
import 'package:model/data_model/genre_response_model.dart';
import 'package:model/data_model/related_film_response_model.dart';
import 'package:model/result_model/implementation/configuration_result_model.dart';
import 'package:model/result_model/implementation/film_details_result_model.dart';
import 'package:model/result_model/implementation/genre_result_model.dart';
import 'package:model/result_model/implementation/list_film_result_model.dart';
import 'package:model/result_model/implementation/related_film_result_model.dart';
import 'package:model/result_model/interface/configuration_result_model_interface.dart';
import 'package:model/result_model/interface/film_details_result_model_interface.dart';
import 'package:model/result_model/interface/genre_result_model_interface.dart';
import 'package:model/result_model/interface/list_film_result_model_interface.dart';
import 'package:model/result_model/interface/related_film_result_model_interface.dart';
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
  Future<ListFilmResponseInterface> loadFilms() async {
    var response =
        await client.get<Map<String, dynamic>>("movie/popular", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      var films = FilmResponseModel.fromJson(response.data!).films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return ListFilmResponse.success(films);
    }
    return ListFilmResponse.error(ListFilmErrorEnum.serverError);
  }

  @override
  Future<GenreResponseInterface> loadGenres() async {
    if (_genres != null) return GenreResponse.success(_genres!);
    var response =
        await client.get<Map<String, dynamic>>("genre/movie/list", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      _genres = GenreResponseModel.fromJson(response.data!).genres;
      return GenreResponse.success(_genres!);
    }
    return GenreResponse.error(GenreErrorEnum.serverError);
  }

  @override
  Future<ConfigurationResponseInterface> loadImageConfiguration() async {
    if (_configuration != null) return ConfigurationResponse.success(_configuration!);

    var response = await client.get<Map<String, dynamic>>("configuration");
    if (response.data != null) {
      _configuration = ConfigurationModel.fromJson(response.data!).images;
      return ConfigurationResponse.success(_configuration!);
    }
    return ConfigurationResponse.error(ConfigurationErrorEnum.serverError);
  }

  final Map<int, Future<RelatedFilmResponseInterface>> _cachedRelatedFilms = {};

  @override
  Future<RelatedFilmResponseInterface> loadRelatedFilms(int filmId) async {
    var result = await _cachedRelatedFilms.putIfAbsent(filmId, () async {
      var response = await client
          .get<Map<String, dynamic>>("movie/$filmId/similar", queryParameters: {"language": "it-IT", "page": 1});

      if (response.data != null) {
        var films = RelatedFilmResponseModel.fromJson(response.data!).films;
        films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
        return RelatedFilmResponse.success(films);
      }
      return RelatedFilmResponse.error(RelatedFilmErrorEnum.serverError);
    });

    if (result.responseValue == null) {
      _cachedFilm.remove(filmId);
    }
    return result;
  }

  @override
  Future<FilmDetailsResponseInterface> loadFilm(int filmId) async {
    var film = _cachedFilm[filmId];

    if (film != null) {
      return FilmDetailsResponse.success(film);
    }
    return FilmDetailsResponse.error(FilmErrorEnum.filmNotFound);
  }
}
