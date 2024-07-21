import 'package:flutter_architecture/model/model_utils.dart';

class Genre {
  static const _idKey = "id";
  static const _nameKey = "name";

  int id;
  String name;

  Genre.fromJson(Map<String, dynamic> json)
      : id = ModelUtils.parse<int>(json[_idKey], -1),
        name = ModelUtils.parse<String>(json[_nameKey], "");
}
