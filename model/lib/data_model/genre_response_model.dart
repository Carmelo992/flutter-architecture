import 'package:model/data_model/genre_model.dart';
import 'package:model/data_model/model_utils.dart';

class GenreResponseModel {
  static const _genresKey = "genres";
  List<GenreModel> genres;

  GenreResponseModel.fromJson(Map<String, dynamic> json)
      : genres = ModelUtils.parse(json[_genresKey], []).map((e) => GenreModel.fromJson(e)).toList();
}
