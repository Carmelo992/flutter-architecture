import 'dart:typed_data';

import 'package:model/result_model/result_model.dart';

abstract class ImageResult extends ResultModel<Uint8List, ImageErrorEnum> {
  ImageResult.error(super.errorValue) : super.error();

  ImageResult.success(super.responseValue) : super.success();
}

enum ImageErrorEnum {
  imageDownloading,
  imageNotFound,
  alreadyDownloaded,
  serverError;
}
