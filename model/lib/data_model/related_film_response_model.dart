import 'package:model/data_model/film_model.dart';
import 'package:model/data_model/model_utils.dart';

class RelatedFilmResponseModel {
  static const _pageKey = "page";
  static const _resultsKey = "results";
  static const _totalPagesKey = "total_pages";
  static const _totalResultsKey = "total_results";

  int page;
  List<FilmModel> films;
  int totalPages;
  int totalResults;

  RelatedFilmResponseModel.fromJson(Map<String, dynamic> json)
      : page = ModelUtils.parse(json[_pageKey], 1),
        totalPages = ModelUtils.parse(json[_totalPagesKey], 1),
        totalResults = ModelUtils.parse(json[_totalResultsKey], 0),
        films = ModelUtils.parse<List>(json[_resultsKey], []).map((e) => FilmModel.fromJson(e)).toList();
}
