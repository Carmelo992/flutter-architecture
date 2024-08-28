import 'package:flutter_test/flutter_test.dart';
import 'package:model/model.dart';
import 'package:view_model/view_model.dart';

import 'fake_services/fake_app_services_impl.dart';
import 'fake_services/fake_image_services_impl.dart';

void main() {
  group("Test FilmDetailViewModel", () {
    AppServiceInterface fakeAppService = FakeAppService();
    ImageServiceInterface fakeImageService = FakeImageService();
    FilmDetailViewModelInterface filmDetailViewModel = FilmDetailViewModel(fakeAppService, fakeImageService);

    test('check empty ViewModel on startup', () {
      AppServiceInterface fakeAppService = FakeAppService();
      ImageServiceInterface fakeImageService = FakeImageService();
      FilmDetailViewModelInterface filmDetailViewModel = FilmDetailViewModel(fakeAppService, fakeImageService);
      expect(filmDetailViewModel.film.value, isNull);
      expect(filmDetailViewModel.relatedFilms.value, isNull);
      expect(filmDetailViewModel.genres.value, isNull);
    });

    test('check ViewModel loaded', () async {
      filmDetailViewModel.loadFilm(1022789);
      await Future.delayed(const Duration(seconds: 5));
      expect(filmDetailViewModel.film.value, isNotNull);
      expect(filmDetailViewModel.film.value!.id, equals(1022789));
      expect(filmDetailViewModel.relatedFilms.value, isNotNull);
      expect(filmDetailViewModel.relatedFilms.value, isNotEmpty);
    });
  });

  group("Test FilmViewModel", () {
    AppServiceInterface fakeAppService = FakeAppService();
    ImageServiceInterface fakeImageService = FakeImageService();
    FilmViewModelInterface filmViewModel = FilmViewModel(fakeAppService, fakeImageService);

    test('check empty ViewModel on startup', () {
      AppServiceInterface fakeAppService = FakeAppService();
      ImageServiceInterface fakeImageService = FakeImageService();
      FilmViewModelInterface filmViewModel = FilmViewModel(fakeAppService, fakeImageService);
      expect(filmViewModel.films.value, isNull);
      expect(filmViewModel.genres.value, isNull);
    });

    test('check ViewModel loaded', () async {
      await Future.delayed(const Duration(seconds: 3));
      expect(filmViewModel.films.value, isNotEmpty);
      expect(filmViewModel.genres.value, isNotEmpty);
    });

    test('check ViewModel film conversion', () async {
      var configuration = await fakeAppService.loadImageConfiguration();
      var modelFilms = await fakeAppService.loadFilms();
      expect(configuration, isNotNull);
      var fakeFilm = modelFilms?.map((e) => FilmUiModel.fromModel(e, configuration!)).toList();
      expect(fakeFilm, isNotNull);
      var vmFilms = filmViewModel.films.value;
      expect(vmFilms, isNotNull);
      expect(vmFilms!.map((e) => e.id), orderedEquals(fakeFilm!.map((e) => e.id)));
    });
  });
}
