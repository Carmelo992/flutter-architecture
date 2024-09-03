import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
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

  static ArchitectureRouter initialize(
      {required Function<T extends Object>(String name) pushScope,
      required Function(String name) popScope,
      required Function<T extends Object>() getVm,
      String? initialLocation,
      Function(String route)? routeListener}) {
    _instance ??= ArchitectureRouter._(
      initialLocation: initialLocation,
      routeListener: routeListener,
      getVm: getVm,
      pushScope: pushScope,
      popScope: popScope,
    );
    return _instance!;
  }

  final Function<T extends Object>() _getVm;
  final Function<T extends Object>(String name) _pushScope;
  final Function(String name) _popScope;

  T getVm<T extends Object>() => _getVm<T>();

  void pushScope<T extends Object>(String name) => _pushScope<T>(name);

  void popScope(String name) => _popScope(name);

  String? initialLocation;

  ArchitectureRouter._(
      {required Function<T extends Object>(String name) pushScope,
      required Function(String name) popScope,
      required Function<T extends Object>() getVm,
      this.initialLocation,
      Function(String route)? routeListener})
      : _pushScope = pushScope,
        _popScope = popScope,
        _getVm = getVm {
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
      vm: ArchitectureRouter.instance.getVm<FilmViewModel>(),
      openDetail: (filmId, context) => DetailsScreenData(filmId, 0).go(context),
    );
  }
}

class DetailsScreenData extends GoRouteData {
  final int id;
  final int counter;

  DetailsScreenData(this.id, this.counter) {
    ArchitectureRouter.instance.pushScope<FilmDetailViewModel>("$counter-$id");
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DetailsPage(
      ArchitectureRouter.instance.getVm<FilmDetailViewModel>(),
      filmId: id,
      openDetail: (filmId, context) => DetailsScreenData(filmId, counter + 1).push(context),
    );
  }

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) {
    ArchitectureRouter.instance.popScope("$counter-$id");
    return super.onExit(context, state);
  }
}
