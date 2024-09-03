import 'package:model/data_model/film_model.dart';
import 'package:model/result_model/result_model_interface.dart';

abstract class RelatedFilmResponseInterface extends ResultInterface<List<FilmModel>, RelatedFilmErrorEnum> {
  RelatedFilmResponseInterface.error(super.errorValue) : super.error();

  RelatedFilmResponseInterface.success(super.responseValue) : super.success();
}

enum RelatedFilmErrorEnum {
  filmNotFound,
  noRelatedFilms,
  missingAuthToken,
  serverError;
}
