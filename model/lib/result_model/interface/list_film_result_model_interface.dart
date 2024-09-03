import 'package:model/data_model/film_model.dart';
import 'package:model/result_model/result_model_interface.dart';

abstract class ListFilmResponseInterface extends ResultInterface<List<FilmModel>, ListFilmErrorEnum> {
  ListFilmResponseInterface.error(super.errorValue) : super.error();

  ListFilmResponseInterface.success(super.responseValue) : super.success();
}

enum ListFilmErrorEnum {
  noFilms,
  missingAuthToken,
  serverError;
}
