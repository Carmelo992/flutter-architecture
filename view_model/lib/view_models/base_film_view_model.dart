import 'package:flutter/foundation.dart';
import 'package:model/model.dart';
import 'package:view_model/ui_model/genre_ui_model.dart';

abstract class BaseFilmViewModel {
  ValueListenable<List<GenreUIModel>?> get genres;

  Uint8List? cachedImage(String path);
}

abstract class BaseImageFilmViewModel implements BaseFilmViewModel {
  ImageService get imageService;

  @override
  Uint8List? cachedImage(String path) => imageService.cachedImage(path).responseValue;
}
