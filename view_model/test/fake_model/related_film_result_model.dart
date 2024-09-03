import 'package:model/model.dart';

class RelatedFilmResponse extends RelatedFilmResult {
  RelatedFilmResponse.error(super.errorValue) : super.error();

  RelatedFilmResponse.success(super.responseValue) : super.success();
}
