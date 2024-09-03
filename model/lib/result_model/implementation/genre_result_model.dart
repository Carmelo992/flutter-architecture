import 'package:model/result_model/interface/genre_result_model_interface.dart';

class GenreResponse extends GenreResponseInterface {
  GenreResponse.error(super.errorValue) : super.error();

  GenreResponse.success(super.responseValue) : super.success();
}
