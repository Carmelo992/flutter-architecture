import 'package:model/result_model/list_film/list_film_result_model.dart';

class ListFilmResultImpl extends ListFilmResult {
  ListFilmResultImpl.error(super.errorValue) : super.error();

  ListFilmResultImpl.success(super.responseValue) : super.success();
}
