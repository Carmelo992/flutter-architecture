import 'package:flutter/foundation.dart';

abstract class ImageServiceInterface {
  Uint8List? cachedImage(String path);

  void downloadImage(String path);
}
