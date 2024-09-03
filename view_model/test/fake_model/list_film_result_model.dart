import 'package:model/model.dart';

class ListFilmResponse extends ListFilmResult {
  ListFilmResponse.error(super.errorValue) : super.error();

  ListFilmResponse.success(super.responseValue) : super.success();
}
