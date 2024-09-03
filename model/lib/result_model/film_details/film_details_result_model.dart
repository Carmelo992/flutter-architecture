import 'package:model/data_model/film_model.dart';
import 'package:model/result_model/result_model.dart';

abstract class FilmDetailsResult extends ResultModel<FilmModel, FilmErrorEnum> {
  FilmDetailsResult.error(super.errorValue) : super.error();

  FilmDetailsResult.success(super.responseValue) : super.success();
}

enum FilmErrorEnum {
  filmNotFound,
  missingAuthToken,
  serverError;
}
