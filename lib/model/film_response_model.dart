import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/model_utils.dart';

class FilmResponse {
  List<Film> films;
  static const _resultsKey = "results";

  FilmResponse.fromJson(Map<String, dynamic> json)
      : films = ModelUtils.parse<List>(json[_resultsKey], []).map((e) => Film.fromJson(e)).toList();
}
