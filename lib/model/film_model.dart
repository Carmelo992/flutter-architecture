import 'package:flutter_architecture/model/model_utils.dart';
import 'package:intl/intl.dart';

class Film {
  bool forAdult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String? overview;
  num popularity;
  String? posterPath;
  DateTime? releaseDate;
  String title;
  bool video;
  num voteAverage;
  num voteCount;

  static const _forAdultKey = "forAdult";
  static const _backdropPathKey = "backdrop_path";
  static const _genreIdsKey = "genre_ids";
  static const _idKey = "id";
  static const _originalLanguageKey = "original_language";
  static const _originalTitleKey = "original_title";
  static const _overviewKey = "overview";
  static const _popularityKey = "popularity";
  static const _posterPathKey = "poster_path";
  static const _releaseDateKey = "release_date";
  static const _titleKey = "title";
  static const _videoKey = "video";
  static const _voteAverageKey = "vote_average";
  static const _voteCountKey = "vote_count";

  Film.fromJson(Map<String, dynamic> json)
      : forAdult = ModelUtils.parse<bool>(json[_forAdultKey], false),
        backdropPath = ModelUtils.parse<String?>(json[_backdropPathKey], null),
        genreIds = List<int>.from(ModelUtils.parse<List>(json[_genreIdsKey], [])),
        id = ModelUtils.parse<int>(json[_idKey], -1),
        originalLanguage = ModelUtils.parse<String>(json[_originalLanguageKey], ""),
        originalTitle = ModelUtils.parse<String>(json[_originalTitleKey], ""),
        overview = ModelUtils.parse<String?>(json[_overviewKey], null),
        popularity = ModelUtils.parse<num>(json[_popularityKey], 0),
        posterPath = ModelUtils.parse<String?>(json[_posterPathKey], null),
        releaseDate = DateFormat("yyyy-MM-dd").tryParse(ModelUtils.parse<String>(json[_releaseDateKey], "")),
        title = ModelUtils.parse<String>(json[_titleKey], ""),
        video = ModelUtils.parse<bool>(json[_videoKey], false),
        voteAverage = ModelUtils.parse<num>(json[_voteAverageKey], 0),
        voteCount = ModelUtils.parse<num>(json[_voteCountKey], 0);
}
