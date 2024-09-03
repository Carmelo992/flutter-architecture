import 'package:model/data_model/film_model.dart';
import 'package:model/result_model/result_model.dart';

abstract class ListFilmResult extends ModelResult<List<FilmModel>, ListFilmErrorEnum> {
  ListFilmResult.error(super.errorValue) : super.error();

  ListFilmResult.success(super.responseValue) : super.success();
}

enum ListFilmErrorEnum {
  noFilms,
  missingAuthToken,
  serverError;
}
