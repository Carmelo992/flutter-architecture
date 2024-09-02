import 'package:model/data_model/genre_model.dart';
import 'package:model/result_model/result_model_interface.dart';

abstract class GenreResponseInterface extends ResultInterface<List<GenreModel>, GenreErrorEnum> {
  GenreResponseInterface.error(super.errorValue) : super.error();

  GenreResponseInterface.success(super.responseValue) : super.success();
}

enum GenreErrorEnum {
  noGenre,
  missingAuthToken,
  serverError;
}
