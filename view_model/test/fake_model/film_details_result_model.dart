import 'package:model/result_model/interface/film_details_result_model_interface.dart';

class FilmDetailsResponse extends FilmDetailsResponseInterface {
  FilmDetailsResponse.error(super.errorValue) : super.error();

  FilmDetailsResponse.success(super.responseValue) : super.success();
}
