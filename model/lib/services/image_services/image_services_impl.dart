import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:model/services/image_services/image_services.dart';

class ImageService implements ImageServiceInterface {
  late Dio client;

  ImageService() {
    client = Dio();
  }

  final Map<String, Uint8List> _cachedImage = {};
  final List<String> _downloadedImages = [];

  @override
  Uint8List? cachedImage(String path) {
    if (!_cachedImage.containsKey(path)) {
      downloadImage(path);
    }
    return _cachedImage[path];
  }

  @override
  Future<void> downloadImage(String path) async {
    if (_downloadedImages.contains(path)) return;
    if (_cachedImage.containsKey(path)) return;
    try {
      var response = await client.get(path, options: Options(responseType: ResponseType.bytes));
      var data = response.data;
      if (data is Uint8List) {
        _cachedImage.putIfAbsent(path, () => data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
