import 'package:model/data_model/model_utils.dart';

class ConfigurationModel {
  ConfigurationImage images;
  List<String> changeKeys;

  static const _imagesKey = "images";
  static const _changeKeysKey = "change_keys";

  ConfigurationModel.fromJson(Map<String, dynamic> json)
      : images = ConfigurationImage.fromJson(json[_imagesKey] ?? {}),
        changeKeys = List.from(ModelUtils.parse<List>(json[_changeKeysKey], []));
}

class ConfigurationImage {
  static const _baseUrlKey = "base_url";
  static const _secureBaseUrlKey = "secure_base_url";
  static const _backdropSizesKey = "backdrop_sizes";
  static const _logoSizesKey = "logo_sizes";
  static const _posterSizesKey = "poster_sizes";
  static const _profileSizesKey = "profile_sizes";
  static const _stillSizesKey = "still_sizes";

  String baseUrl;
  String secureBaseUrl;
  List<String> backdropSizes;
  List<String> logoSizes;
  List<String> posterSizes;
  List<String> profileSizes;
  List<String> stillSizes;

  ConfigurationImage.fromJson(Map<String, dynamic> json)
      : baseUrl = ModelUtils.parse<String>(json[_baseUrlKey], ""),
        secureBaseUrl = ModelUtils.parse<String>(json[_secureBaseUrlKey], ""),
        backdropSizes = List.from(ModelUtils.parse<List>(json[_backdropSizesKey], [])),
        logoSizes = List.from(ModelUtils.parse<List>(json[_logoSizesKey], [])),
        posterSizes = List.from(ModelUtils.parse<List>(json[_posterSizesKey], [])),
        profileSizes = List.from(ModelUtils.parse<List>(json[_profileSizesKey], [])),
        stillSizes = List.from(ModelUtils.parse<List>(json[_stillSizesKey], []));

  String hdPosterUrl(String posterPath) => "$baseUrl${posterSizes.last}$posterPath";

  String ldPosterUrl(String posterPath) => "$baseUrl${posterSizes.first}$posterPath";

  String hdBackdropUrl(String backdropPath) => "$baseUrl${backdropSizes.last}$backdropPath";

  String ldBackdropUrl(String backdropPath) => "$baseUrl${backdropSizes.first}$backdropPath";
}
