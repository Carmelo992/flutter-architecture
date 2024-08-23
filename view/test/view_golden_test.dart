import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:view/view.dart';
import 'package:view/widgets/backdrop_widget.dart';
import 'package:view/widgets/details_film_header.dart';
import 'package:view/widgets/film_card.dart';
import 'package:view/widgets/poster_widget.dart';
import 'package:view_model/view_model.dart';

import 'mocked_ui_models/mocked_film_ui_model.dart';
import 'mocked_view_models/mocked_film_details_view_model.dart';
import 'mocked_view_models/mocked_film_view_model.dart';

void main() {
  var devices = getDevices();
  var surfaceSize = getPngSize(devices);

  group("Widget testing", () {
    FilmUiModel film = MockedFilmUiModel();
    FilmViewModelInterface vm = MockedFilmViewModel();

    testGoldens('Poster widget', (tester) async {
      await loadAppFonts();
      var widget = MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: Center(
          child: PosterWidget(film: film, vm: vm),
        ),
      );
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: devices)
        ..addScenario(name: 'Poster', widget: widget);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, 'poster_types_grid');
    });

    testGoldens('Sized Poster widget', (tester) async {
      await loadAppFonts();
      var widget = MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: Center(
          child: AspectRatio(aspectRatio: 9 / 16, child: PosterWidget(film: film, vm: vm, height: 180)),
        ),
      );
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: devices)
        ..addScenario(name: 'Sized Poster', widget: widget);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, 'sized_poster_types_grid');
    });

    testGoldens('Backdrop widget', (tester) async {
      await loadAppFonts();
      var widget = MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: Center(
          child: BackdropWidget(film: film, vm: vm),
        ),
      );
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: devices)
        ..addScenario(name: 'Backdrop', widget: widget);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, 'backdrop_types_grid');
    });

    testGoldens('FilmCard widget', (tester) async {
      await loadAppFonts();
      var widget = MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: Center(
          child: FilmCard(film: film, vm: vm, openDetail: null),
        ),
      );
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: devices)
        ..addScenario(name: 'FilmCard', widget: widget);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, 'film_card_types_grid');
    });

    testGoldens('Details film header widget', (tester) async {
      await loadAppFonts();
      var widget = MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: Scaffold(
          body: Column(
            children: [
              DetailsHeader(film: film, vm: vm),
            ],
          ),
        ),
      );
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: devices)
        ..addScenario(name: 'Details header', widget: widget);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, 'details_header_types_grid');
    });
  });

  group("Screen testing", () {
    FilmViewModelInterface vm = MockedFilmViewModel();
    testGoldens("Films page", (tester) async {
      await loadAppFonts();
      var widget = MaterialApp(
        supportedLocales: AppLocalization.supportedLocales,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
        home: FilmPage(vm: vm, openDetail: null),
      );
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: devices)
        ..addScenario(name: 'Film page', widget: widget);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
      await screenMatchesGolden(tester, 'film_page_types_grid');
    });
  });

  testGoldens("Film details page", (tester) async {
    await loadAppFonts();
    var film = MockedFilmUiModel();
    var vm = MockedFilmDetailsViewModel();
    var widget = MaterialApp(
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      theme: ThemeData(colorScheme: const ColorScheme.dark(), useMaterial3: true),
      home: DetailsPage(vm, filmId: film.id, openDetail: null),
    );
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: devices)
      ..addScenario(name: 'Film details page', widget: widget);
    await tester.pumpWidgetBuilder(builder.build(), surfaceSize: surfaceSize);
    await screenMatchesGolden(tester, 'film_details_page_types_grid');
  });
}

List<Device> getDevices() {
  List<double> scales = [1, 2, 3];
  List<Device> devices = [
    Device.phone,
    Device.iphone11,
    Device.tabletPortrait,
    Device.tabletLandscape,
  ];

  List<Device> scaledDevice = [];

  for (var device in devices) {
    for (var scale in scales) {
      scaledDevice.add(device.copyWith(textScale: scale, name: "${device.name} ${scale}x"));
    }
  }

  return scaledDevice;
}

Size getPngSize(List<Device> devices) {
  double width = devices.map((e) => e.size.width).reduce((a, b) => a + b) + 20 * devices.length;
  double height = devices.map((e) => e.size.height).reduce(max) + 30;

  return Size(width, height);
}
