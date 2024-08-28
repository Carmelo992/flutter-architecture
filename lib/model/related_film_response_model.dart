import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/model_utils.dart';

class RelatedFilmResponse {
  static const _pageKey = "page";
  static const _resultsKey = "results";
  static const _totalPagesKey = "total_pages";
  static const _totalResultsKey = "total_results";

  int page;
  List<Film> films;
  int totalPages;
  int totalResults;

  RelatedFilmResponse.fromJson(Map<String, dynamic> json)
      : page = ModelUtils.parse(json[_pageKey], 1),
        totalPages = ModelUtils.parse(json[_totalPagesKey], 1),
        totalResults = ModelUtils.parse(json[_totalResultsKey], 0),
        films = ModelUtils.parse<List>(json[_resultsKey], []).map((e) => Film.fromJson(e)).toList();
}
