import 'package:model/model.dart';

class FilmDetailsResponse extends FilmDetailsResult {
  FilmDetailsResponse.error(super.errorValue) : super.error();

  FilmDetailsResponse.success(super.responseValue) : super.success();
}
