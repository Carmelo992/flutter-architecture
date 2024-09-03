import 'package:model/result_model/interface/related_film_result_model_interface.dart';

class RelatedFilmResponse extends RelatedFilmResponseInterface {
  RelatedFilmResponse.error(super.errorValue) : super.error();

  RelatedFilmResponse.success(super.responseValue) : super.success();
}
