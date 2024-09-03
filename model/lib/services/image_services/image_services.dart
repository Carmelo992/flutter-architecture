import 'package:model/result_model/image/image_result_model.dart';

abstract class ImageService {
  ImageResult cachedImage(String path);

  Future<void> downloadImage(String path);
}
