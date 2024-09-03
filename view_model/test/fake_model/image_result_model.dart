import 'package:model/model.dart';

class ImageResponse extends ImageResult {
  ImageResponse.error(super.errorValue) : super.error();

  ImageResponse.success(super.responseValue) : super.success();
}
