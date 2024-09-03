import 'package:dio/dio.dart';
import 'package:model/data_model/configuration_model.dart';
import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/film_response_model.dart';
import 'package:model/data_model/genre_model.dart';
import 'package:model/data_model/genre_response_model.dart';
import 'package:model/data_model/related_film_response_model.dart';
import 'package:model/result_model/configuration/configuration_result_model.dart';
import 'package:model/result_model/configuration/configuration_result_model_impl.dart';
import 'package:model/result_model/film_details/film_details_result_model.dart';
import 'package:model/result_model/film_details/film_details_result_model_impl.dart';
import 'package:model/result_model/genre/genre_result_model.dart';
import 'package:model/result_model/genre/genre_result_model_impl.dart';
import 'package:model/result_model/list_film/list_film_result_model.dart';
import 'package:model/result_model/list_film/list_film_result_model_impl.dart';
import 'package:model/result_model/related_film/related_film_result_model.dart';
import 'package:model/result_model/related_film/related_film_result_model_impl.dart';
import 'package:model/services/app_services/app_services.dart';

class AppServiceImpl implements AppService {
  late Dio client;
  final Map<int, FilmModel> _cachedFilm = {};
  List<GenreModel>? _genres;
  ConfigurationImage? _configuration;

  AppServiceImpl() {
    client = Dio(
      BaseOptions(
        baseUrl: "https://api.themoviedb.org/3/",
        queryParameters: {"api_key": "213c1a1d1f356ed0bf10c9656ab5d5cb"},
      ),
    );
  }

  @override
  Future<ListFilmResult> loadFilms() async {
    var response =
        await client.get<Map<String, dynamic>>("movie/popular", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      var films = FilmResponseModel.fromJson(response.data!).films;
      films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
      return ListFilmResultImpl.success(films);
    }
    return ListFilmResultImpl.error(ListFilmErrorEnum.serverError);
  }

  @override
  Future<GenreResult> loadGenres() async {
    if (_genres != null) return GenreResultImpl.success(_genres!);
    var response =
        await client.get<Map<String, dynamic>>("genre/movie/list", queryParameters: {"language": "it-IT", "page": 1});
    if (response.data != null) {
      _genres = GenreResponseModel.fromJson(response.data!).genres;
      return GenreResultImpl.success(_genres!);
    }
    return GenreResultImpl.error(GenreErrorEnum.serverError);
  }

  @override
  Future<ConfigurationResult> loadImageConfiguration() async {
    if (_configuration != null) return ConfigurationResultImpl.success(_configuration!);

    var response = await client.get<Map<String, dynamic>>("configuration");
    if (response.data != null) {
      _configuration = ConfigurationModel.fromJson(response.data!).images;
      return ConfigurationResultImpl.success(_configuration!);
    }
    return ConfigurationResultImpl.error(ConfigurationErrorEnum.serverError);
  }

  final Map<int, Future<RelatedFilmResult>> _cachedRelatedFilms = {};

  @override
  Future<RelatedFilmResult> loadRelatedFilms(int filmId) async {
    var result = await _cachedRelatedFilms.putIfAbsent(filmId, () async {
      var response = await client
          .get<Map<String, dynamic>>("movie/$filmId/similar", queryParameters: {"language": "it-IT", "page": 1});

      if (response.data != null) {
        var films = RelatedFilmResponseModel.fromJson(response.data!).films;
        films.forEach((film) => _cachedFilm.putIfAbsent(film.id, () => film));
        return RelatedFilmResultImpl.success(films);
      }
      return RelatedFilmResultImpl.error(RelatedFilmErrorEnum.serverError);
    });

    if (result.responseValue == null) {
      _cachedFilm.remove(filmId);
    }
    return result;
  }

  @override
  Future<FilmDetailsResult> loadFilm(int filmId) async {
    var film = _cachedFilm[filmId];

    if (film != null) {
      return FilmDetailsResultImpl.success(film);
    }
    return FilmDetailsResultImpl.error(FilmErrorEnum.filmNotFound);
  }
}
