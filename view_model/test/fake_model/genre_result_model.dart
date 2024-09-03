import 'package:model/model.dart';

class GenreResponse extends GenreResult {
  GenreResponse.error(super.errorValue) : super.error();

  GenreResponse.success(super.responseValue) : super.success();
}
