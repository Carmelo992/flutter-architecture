import 'package:model/result_model/interface/list_film_result_model_interface.dart';

class ListFilmResponse extends ListFilmResponseInterface {
  ListFilmResponse.error(super.errorValue) : super.error();

  ListFilmResponse.success(super.responseValue) : super.success();
}
