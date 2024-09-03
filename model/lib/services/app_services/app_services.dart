import 'package:model/result_model/interface/configuration_result_model_interface.dart';
import 'package:model/result_model/interface/film_details_result_model_interface.dart';
import 'package:model/result_model/interface/genre_result_model_interface.dart';
import 'package:model/result_model/interface/list_film_result_model_interface.dart';
import 'package:model/result_model/interface/related_film_result_model_interface.dart';

abstract class AppServiceInterface {
  Future<ListFilmResponseInterface> loadFilms();

  Future<GenreResponseInterface> loadGenres();

  Future<ConfigurationResponseInterface> loadImageConfiguration();

  Future<RelatedFilmResponseInterface> loadRelatedFilms(int filmId);

  Future<FilmDetailsResponseInterface> loadFilm(int filmId);
}
