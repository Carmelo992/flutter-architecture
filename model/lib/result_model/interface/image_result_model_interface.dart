import 'dart:typed_data';

import 'package:model/result_model/result_model_interface.dart';

abstract class ImageResponseInterface extends ResultInterface<Uint8List, ImageErrorEnum> {
  ImageResponseInterface.error(super.errorValue) : super.error();

  ImageResponseInterface.success(super.responseValue) : super.success();
}

enum ImageErrorEnum {
  imageDownloading,
  imageNotFound,
  alreadyDownloaded,
  serverError;
}
