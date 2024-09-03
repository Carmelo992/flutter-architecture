import 'package:model/data_model/genre_model.dart';
import 'package:model/result_model/result_model.dart';

abstract class GenreResult extends ResultModel<List<GenreModel>, GenreErrorEnum> {
  GenreResult.error(super.errorValue) : super.error();

  GenreResult.success(super.responseValue) : super.success();
}

enum GenreErrorEnum {
  noGenre,
  missingAuthToken,
  serverError;
}
