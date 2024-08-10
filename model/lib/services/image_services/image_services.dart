import 'package:flutter/foundation.dart';

abstract class ImageServiceInterface {
  Uint8List? cachedImage(String path);

  Future<void> downloadImage(String path);
}
