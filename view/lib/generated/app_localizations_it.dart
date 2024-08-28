import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationIt extends AppLocalization {
  AppLocalizationIt([String locale = 'it']) : super(locale);

  @override
  String get name => 'Flutter Architecture';

  @override
  String get vote_average => 'Media voto:';

  @override
  String get total_votes => 'Voti ricevuti:';

  @override
  String get popularity => 'Popolarità:';

  @override
  String get release_date => 'Uscita:';

  @override
  String get genre => 'Genere:';

  @override
  String get description => 'Descrizione:';

  @override
  String get similar_films => 'Film simili (??):';

  @override
  String get date_format => 'dd/MM/yy';
}
