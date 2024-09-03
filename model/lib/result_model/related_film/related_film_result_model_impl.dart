import 'package:model/result_model/related_film/related_film_result_model.dart';

class RelatedFilmResultImpl extends RelatedFilmResult {
  RelatedFilmResultImpl.error(super.errorValue) : super.error();

  RelatedFilmResultImpl.success(super.responseValue) : super.success();
}
