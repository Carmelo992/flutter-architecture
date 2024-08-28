import 'package:model/data_model/configuration_model.dart';
import 'package:model/data_model/film_model.dart';

class FilmUiModel {
  String? backdropPathHd;
  String? backdropPathLd;
  List<int> genreIds;
  int id;
  String? overview;
  num popularity;
  String? posterPathHd;
  String? posterPathLd;
  DateTime? releaseDate;
  String title;
  num voteAverage;
  num voteCount;

  FilmUiModel.fromModel(FilmModel model, ConfigurationImage? configImage)
      : backdropPathHd = model.backdropPath != null ? configImage?.hdBackdropUrl(model.backdropPath!) : null,
        backdropPathLd = model.backdropPath != null ? configImage?.ldBackdropUrl(model.backdropPath!) : null,
        genreIds = model.genreIds,
        id = model.id,
        overview = model.overview,
        popularity = model.popularity,
        posterPathHd = model.posterPath != null ? configImage?.hdPosterUrl(model.posterPath!) : null,
        posterPathLd = model.posterPath != null ? configImage?.ldPosterUrl(model.posterPath!) : null,
        releaseDate = model.releaseDate,
        title = model.title,
        voteAverage = model.voteAverage,
        voteCount = model.voteCount;
}
