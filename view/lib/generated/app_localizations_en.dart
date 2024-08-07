import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationEn extends AppLocalization {
  AppLocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get name => 'Flutter Architecture';

  @override
  String get vote_average => 'Vore avg:';

  @override
  String get total_votes => 'Votes:';

  @override
  String get popularity => 'Popularity:';

  @override
  String get release_date => 'Release date:';

  @override
  String get genre => 'Genre:';

  @override
  String get description => 'Description:';

  @override
  String get similar_films => 'Related films (??):';

  @override
  String get date_format => 'MM/dd/yyyy';
}
