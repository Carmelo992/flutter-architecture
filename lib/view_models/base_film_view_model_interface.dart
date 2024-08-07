import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/image_services.dart';

abstract class BaseFilmViewModelInterface {
  ValueListenable<List<Genre>?> get genres;

  ValueListenable<ConfigurationImage?> get imgConfig;

  Uint8List? cachedImage(String path);
}

abstract class BaseFilmViewModel implements BaseFilmViewModelInterface {
  ImageServiceInterface get imageService;

  @override
  Uint8List? cachedImage(String path) => imageService.cachedImage(path);
}
