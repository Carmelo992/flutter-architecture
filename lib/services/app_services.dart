import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/app_services_impl.dart';

abstract class AppServiceInterface {
  Future<List<Film>?> loadFilms();

  Future<List<Genre>?> loadGenres();

  Future<ConfigurationImage?> loadImageConfiguration();

  Future<List<Film>?> loadRelatedFilms(int filmId);

  static AppServiceInterface getImpl() => AppService.instance;
}
