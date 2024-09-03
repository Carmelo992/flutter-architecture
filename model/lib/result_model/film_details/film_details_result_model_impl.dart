import 'package:model/result_model/film_details/film_details_result_model.dart';

class FilmDetailsResultImpl extends FilmDetailsResult {
  FilmDetailsResultImpl.error(super.errorValue) : super.error();

  FilmDetailsResultImpl.success(super.responseValue) : super.success();
}
