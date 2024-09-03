import 'package:model/result_model/genre/genre_result_model.dart';

class GenreResultImpl extends GenreResult {
  GenreResultImpl.error(super.errorValue) : super.error();

  GenreResultImpl.success(super.responseValue) : super.success();
}
