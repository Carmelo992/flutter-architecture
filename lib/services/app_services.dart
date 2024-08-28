import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';

abstract class AppServiceInterface {
  Future<List<Film>?> loadFilms();

  Future<List<Genre>?> loadGenres();

  Future<ConfigurationImage?> loadImageConfiguration();

  Future<List<Film>?> loadRelatedFilms(int filmId);

  Future<Film?> loadFilm(int filmId);
}
