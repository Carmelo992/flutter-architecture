import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/services/image_services.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_impl.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_interface.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';
import 'package:flutter_architecture/views/details_screen.dart';
import 'package:flutter_architecture/views/film_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

//Script to generate routes: flutter pub run build_runner build --delete-conflicting-outputs

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
    errorBuilder: (context, state) {
      debugPrint("state: $state");
      return Container();
    },
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return null;
    },
  );
}

@TypedGoRoute<SplashScreenData>(path: '/home', routes: [TypedGoRoute<DetailsScreenData>(path: 'details/:counter/:id')])
class SplashScreenData extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MyHomePage(vm: GetIt.instance.get<FilmViewModelInterface>());
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
    return DetailsPage(GetIt.instance.get<FilmDetailViewModelInterface>(), filmId: id, counter: counter);
  }

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) {
    if (GetIt.instance.hasScope("$counter-$id")) {
      GetIt.instance.dropScope("$counter-$id");
    }
    return super.onExit(context, state);
  }
}
