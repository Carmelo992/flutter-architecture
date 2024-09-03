import 'package:model/result_model/image/image_result_model.dart';

class ImageResultImpl extends ImageResult {
  ImageResultImpl.error(super.errorValue) : super.error();

  ImageResultImpl.success(super.responseValue) : super.success();
}
