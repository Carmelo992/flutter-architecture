import 'package:model/data_model/film_model.dart';
import 'package:model/result_model/result_model_interface.dart';

abstract class FilmDetailsResponseInterface extends ResultInterface<FilmModel, FilmErrorEnum> {
  FilmDetailsResponseInterface.error(super.errorValue) : super.error();

  FilmDetailsResponseInterface.success(super.responseValue) : super.success();
}

enum FilmErrorEnum {
  filmNotFound,
  missingAuthToken,
  serverError;
}
