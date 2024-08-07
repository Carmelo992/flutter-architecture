import 'package:model/data_model/genre_model.dart';

class GenreUIModel {
  int id;
  String name;

  GenreUIModel.fromModel(GenreModel model)
      : id = model.id,
        name = model.name;
}
