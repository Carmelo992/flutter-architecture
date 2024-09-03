import 'package:flutter/foundation.dart';
import 'package:model/model.dart';

import '../fake_model/image_result_model.dart';
import '../fake_raw_data//fake_image.dart';

class FakeImageService implements ImageService {
  FakeImageService();

  final Map<String, Uint8List> _cachedImage = {};

  @override
  ImageResult cachedImage(String path) {
    if (!_cachedImage.containsKey(path)) {
      downloadImage(path);
    }
    return ImageResponse.success(_cachedImage[path]!);
  }

  @override
  Future<ImageResult> downloadImage(String path) async {
    _cachedImage.putIfAbsent(path, () => fakeImage);
    return ImageResponse.success(fakeImage);
  }
}
