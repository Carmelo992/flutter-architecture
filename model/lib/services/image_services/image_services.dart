import 'package:model/result_model/interface/image_result_model_interface.dart';

abstract class ImageServiceInterface {
  ImageResponseInterface cachedImage(String path);

  Future<void> downloadImage(String path);
}
