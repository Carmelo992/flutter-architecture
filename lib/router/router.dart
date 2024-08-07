import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:model/model.dart';
import 'package:view/view.dart';
import 'package:view_model/view_model.dart';

part 'router.g.dart';

class ArchitectureRouter {
  static ArchitectureRouter? _instance;

  static ArchitectureRouter get instance {
    if (_instance == null) {
      throw "ArchitectureRouter not initialized. Call initialize method before require an instance";
    }
    return _instance!;
  }

  static ArchitectureRouter initialize({String? initialLocation, Function(String route)? routeListener}) {
    _instance ??= ArchitectureRouter._(initialLocation, routeListener);
    return _instance!;
  }

  String? initialLocation;

  ArchitectureRouter._([this.initialLocation, Function(String route)? routeListener]) {
    router.routeInformationProvider.addListener(() {
      routeListener?.call(router.routeInformationProvider.value.uri.path);
    });
  }

  late GoRouter router = GoRouter(
    routes: $appRoutes,
    initialLocation: initialLocation ?? SplashScreenData().location,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return null;
    },
  );
}

@TypedGoRoute<SplashScreenData>(path: '/')
class SplashScreenData extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashPage(goHome: (context) => HomeScreenData().go(context));
  }
}

@TypedGoRoute<HomeScreenData>(path: '/home', routes: [
  TypedGoRoute<DetailsScreenData>(path: 'details/:id'),
])
class HomeScreenData extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FilmPage(
      vm: GetIt.instance.get<FilmViewModelInterface>(),
      openDetail: (filmId, context) => DetailsScreenData(filmId, 0).go(context),
    );
  }
}

class DetailsScreenData extends GoRouteData {
  final int id;
  final int counter;

  DetailsScreenData(this.id, this.counter) {
    if (!GetIt.instance.hasScope("$counter-$id")) {
      GetIt.instance.pushNewScope(
        init: (getIt) {
          getIt.registerSingleton<FilmDetailViewModelInterface>(FilmDetailViewModel(
            getIt.get<AppServiceInterface>(),
            getIt.get<ImageServiceInterface>(),
          ));
        },
        scopeName: "$counter-$id",
      );
    }
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DetailsPage(
      GetIt.instance.get<FilmDetailViewModelInterface>(),
      filmId: id,
      openDetail: (filmId, context) => DetailsScreenData(filmId, counter + 1).push(context),
    );
  }

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) {
    if (GetIt.instance.hasScope("$counter-$id")) {
      GetIt.instance.dropScope("$counter-$id");
    }
    return super.onExit(context, state);
  }
}
