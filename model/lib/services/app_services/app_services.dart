import 'package:model/data_model/configuration_model.dart';
import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/genre_model.dart';

abstract class AppServiceInterface {
  Future<List<FilmModel>?> loadFilms();

  Future<List<GenreModel>?> loadGenres();

  Future<ConfigurationImage?> loadImageConfiguration();

  Future<List<FilmModel>?> loadRelatedFilms(int filmId);

  Future<FilmModel?> loadFilm(int filmId);
}
