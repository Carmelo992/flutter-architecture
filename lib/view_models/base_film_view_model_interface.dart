import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/ui_model/genre_ui_model.dart';
import 'package:model/model.dart';

abstract class BaseFilmViewModelInterface {
  ValueListenable<List<GenreUIModel>?> get genres;

  Uint8List? cachedImage(String path);
}

abstract class BaseFilmViewModel implements BaseFilmViewModelInterface {
  ImageServiceInterface get imageService;

  @override
  Uint8List? cachedImage(String path) => imageService.cachedImage(path);
}
