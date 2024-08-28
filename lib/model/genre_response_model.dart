import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/model/model_utils.dart';

class GenreResponse {
  static const _genresKey = "genres";
  List<Genre> genres;

  GenreResponse.fromJson(Map<String, dynamic> json)
      : genres = ModelUtils.parse(json[_genresKey], []).map((e) => Genre.fromJson(e)).toList();
}
