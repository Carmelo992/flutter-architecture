import 'package:model/result_model/interface/image_result_model_interface.dart';

class ImageResponse extends ImageResponseInterface {
  ImageResponse.error(super.errorValue) : super.error();

  ImageResponse.success(super.responseValue) : super.success();
}
