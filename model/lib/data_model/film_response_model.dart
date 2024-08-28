import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/model_utils.dart';

class FilmResponseModel {
  List<FilmModel> films;
  static const _resultsKey = "results";

  FilmResponseModel.fromJson(Map<String, dynamic> json)
      : films = ModelUtils.parse<List>(json[_resultsKey], []).map((e) => FilmModel.fromJson(e)).toList();
}
