import 'package:flutter_test/flutter_test.dart';
import 'package:model/model.dart';

void main() {
  group('Test ImageService', () {
    ImageServiceInterface imageService = ImageService();
    String correctUrl = "http://image.tmdb.org/t/p/w92/xJ0YiCfKxouv8DEFoZiq1G1e4x8.jpg";
    test('Check empty cache on startup', () {
      var cachedImage = imageService.cachedImage(correctUrl);
      expect(cachedImage, isNull);
    });

    test('Download image', () async {
      await imageService.downloadImage(correctUrl);
    });

    test('Get image from cache after download', () async {
      var cachedImage = imageService.cachedImage(correctUrl);
      expect(cachedImage, isNotNull);
    });

    test('Try download not existing image', () async {
      String fakeUrl = "http://image.tmdb.org/t/p/original/tqSg1hHiSWhHAhnjDhhevaP0.jpg";
      var cachedImage = imageService.cachedImage(fakeUrl);
      expect(cachedImage, isNull);
      await imageService.downloadImage(fakeUrl);
      cachedImage = imageService.cachedImage(fakeUrl);
      expect(cachedImage, isNull);
    });
  });

  group("Test AppService", () {
    AppServiceInterface appService = AppService();
    List<FilmModel>? films = [];
    List<GenreModel>? genres = [];
    ConfigurationImage? imageConfig;

    test("Get film details before download it", () async {
      var film = films?.firstOrNull;
      expect(film, isNull);
      var details = await appService.loadFilm(film?.id ?? 0);
      expect(details, isNull);
    });

    test("Download film list", () async {
      films = await appService.loadFilms();
      expect(films, isNotNull);
      expect(films, isNotEmpty);
    });

    test("Download genre list", () async {
      genres = await appService.loadGenres();
      expect(genres, isNotNull);
      expect(genres, isNotEmpty);
    });

    test("Download image configuration", () async {
      imageConfig = await appService.loadImageConfiguration();
      expect(imageConfig, isNotNull);
    });

    test("Get film details", () async {
      var film = films?.firstOrNull;
      expect(film, isNotNull);
      var details = await appService.loadFilm(film!.id);
      expect(details, isNotNull);
      expect(details!.id, equals(film.id));
    });
  });
}
