import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:model/result_model/implementation/image_result_model.dart';
import 'package:model/result_model/interface/image_result_model_interface.dart';
import 'package:model/services/image_services/image_services.dart';

class ImageService implements ImageServiceInterface {
  late Dio client;

  ImageService() {
    client = Dio();
  }

  final Map<String, Uint8List> _cachedImage = {};
  final List<String> _downloadedImages = [];

  @override
  ImageResponseInterface cachedImage(String path) {
    bool toDownload = false;
    if (!_cachedImage.containsKey(path)) {
      downloadImage(path);
      toDownload = true;
    }
    var cache = _cachedImage[path];
    if (cache != null) {
      return ImageResponse.success(cache);
    }
    if (toDownload) {
      return ImageResponse.error(ImageErrorEnum.imageDownloading);
    }
    return ImageResponse.error(ImageErrorEnum.imageNotFound);
  }

  @override
  Future<ImageResponseInterface> downloadImage(String path) async {
    if (_downloadedImages.contains(path)) return ImageResponse.error(ImageErrorEnum.alreadyDownloaded);
    if (_cachedImage.containsKey(path)) return ImageResponse.error(ImageErrorEnum.alreadyDownloaded);
    _downloadedImages.add(path);
    try {
      var response = await client.get(path, options: Options(responseType: ResponseType.bytes));
      var data = response.data;
      if (data is Uint8List) {
        _cachedImage.putIfAbsent(path, () => data);
        return ImageResponse.success(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return ImageResponse.error(ImageErrorEnum.serverError);
  }
}
