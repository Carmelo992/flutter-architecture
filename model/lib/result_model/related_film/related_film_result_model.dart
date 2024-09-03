import 'package:model/data_model/film_model.dart';
import 'package:model/result_model/result_model.dart';

abstract class RelatedFilmResult extends ResultModel<List<FilmModel>, RelatedFilmErrorEnum> {
  RelatedFilmResult.error(super.errorValue) : super.error();

  RelatedFilmResult.success(super.responseValue) : super.success();
}

enum RelatedFilmErrorEnum {
  filmNotFound,
  noRelatedFilms,
  missingAuthToken,
  serverError;
}
