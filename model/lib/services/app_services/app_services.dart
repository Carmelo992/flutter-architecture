import 'package:model/result_model/configuration/configuration_result_model.dart';
import 'package:model/result_model/film_details/film_details_result_model.dart';
import 'package:model/result_model/genre/genre_result_model.dart';
import 'package:model/result_model/list_film/list_film_result_model.dart';
import 'package:model/result_model/related_film/related_film_result_model.dart';

abstract class AppService {
  Future<ListFilmResult> loadFilms();

  Future<GenreResult> loadGenres();

  Future<ConfigurationResult> loadImageConfiguration();

  Future<RelatedFilmResult> loadRelatedFilms(int filmId);

  Future<FilmDetailsResult> loadFilm(int filmId);
}
