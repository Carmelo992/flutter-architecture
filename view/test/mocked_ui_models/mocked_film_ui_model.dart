import 'package:view_model/ui_model/film_ui_model.dart';

class MockedFilmUiModel implements FilmUiModel {
  @override
  String? backdropPathHd = "http://image.tmdb.org/t/p/w92/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg";

  @override
  String? backdropPathLd = "http://image.tmdb.org/t/p/w92/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg";

  @override
  List<int> genreIds = [16, 10751, 12, 35, 18];

  @override
  int id = 1022789;

  @override
  String? overview =
      "Il film torna nella mente dell'adolescente Riley proprio quando il quartier generale viene improvvisamente demolito per far posto a qualcosa di completamente inaspettato: nuove Emozioni! Gioia, Tristezza, Rabbia, Paura e Disgusto, che a detta di tutti gestiscono da tempo un'attività di successo, non sanno come comportarsi quando arriva Ansia. E sembra che non sia sola.";

  @override
  num popularity = 7738.12;

  @override
  String? posterPathHd = "http://image.tmdb.org/t/p/w92/hsyNR14TSGklwoHFjPZnPiu6UlV.jpg";

  @override
  String? posterPathLd = "http://image.tmdb.org/t/p/w92/hsyNR14TSGklwoHFjPZnPiu6UlV.jpg";

  @override
  DateTime? releaseDate = DateTime(2024, 6, 11);

  @override
  String title = "Inside Out 2";

  @override
  num voteAverage = 7.716;

  @override
  num voteCount = 1610;
}
