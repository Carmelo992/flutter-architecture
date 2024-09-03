import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:model/result_model/image/image_result_model.dart';
import 'package:model/result_model/image/image_result_model_impl.dart';
import 'package:model/services/image_services/image_services.dart';

class ImageServiceImpl implements ImageService {
  late Dio client;

  ImageServiceImpl() {
    client = Dio();
  }

  final Map<String, Uint8List> _cachedImage = {};
  final List<String> _downloadedImages = [];

  @override
  ImageResult cachedImage(String path) {
    bool toDownload = false;
    if (!_cachedImage.containsKey(path)) {
      downloadImage(path);
      toDownload = true;
    }
    var cache = _cachedImage[path];
    if (cache != null) {
      return ImageResultImpl.success(cache);
    }
    if (toDownload) {
      return ImageResultImpl.error(ImageErrorEnum.imageDownloading);
    }
    return ImageResultImpl.error(ImageErrorEnum.imageNotFound);
  }

  @override
  Future<ImageResult> downloadImage(String path) async {
    if (_downloadedImages.contains(path)) return ImageResultImpl.error(ImageErrorEnum.alreadyDownloaded);
    if (_cachedImage.containsKey(path)) return ImageResultImpl.error(ImageErrorEnum.alreadyDownloaded);
    _downloadedImages.add(path);
    try {
      var response = await client.get(path, options: Options(responseType: ResponseType.bytes));
      var data = response.data;
      if (data is Uint8List) {
        _cachedImage.putIfAbsent(path, () => data);
        return ImageResultImpl.success(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return ImageResultImpl.error(ImageErrorEnum.serverError);
  }
}
