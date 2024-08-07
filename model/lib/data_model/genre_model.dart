import 'package:model/data_model/model_utils.dart';

class GenreModel {
  static const _idKey = "id";
  static const _nameKey = "name";

  int id;
  String name;

  GenreModel.fromJson(Map<String, dynamic> json)
      : id = ModelUtils.parse<int>(json[_idKey], -1),
        name = ModelUtils.parse<String>(json[_nameKey], "");
}
