import 'package:flutter/foundation.dart';
import 'package:model/services/image_services/image_services.dart';

import '../fake_models/fake_image.dart';

class FakeImageService implements ImageServiceInterface {
  FakeImageService();

  final Map<String, Uint8List> _cachedImage = {};

  @override
  Uint8List? cachedImage(String path) {
    if (!_cachedImage.containsKey(path)) {
      downloadImage(path);
    }
    return _cachedImage[path];
  }

  @override
  Future<void> downloadImage(String path) async {
    _cachedImage.putIfAbsent(path, () => fakeImage);
  }
}
