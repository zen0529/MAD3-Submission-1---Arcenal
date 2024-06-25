import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile3_midterm/controller/authcontroller.dart';
import 'package:mobile3_midterm/enum/enum.dart';
import 'package:mobile3_midterm/screens/homescreen.dart';
import 'package:mobile3_midterm/screens/login.dart';
import 'package:mobile3_midterm/screens/logout.dart';
import 'package:mobile3_midterm/wrapper/wrapper.dart';

class GlobalRouter {
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  // Static getter to access the instance through GetIt
  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();

  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;

  FutureOr<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    if (AuthController.I.state == AuthState.authenticated) {
      if (state.matchedLocation == '/login') {
        return '/home';
      }
      return null;
    }
    if (AuthController.I.state != AuthState.authenticated) {
      if (state.matchedLocation == '/login') {
        return null;
      }
      return '/login';
    }
    return null;
  }

  GlobalRouter() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();

    router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: sentimentanalysis.route,
        redirect: handleRedirect,
        refreshListenable: AuthController.I,
        routes: [
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: LogIn.route,
              name: 'Log in',
              builder: (context, _) {
                return const LogIn();
              }),
          ShellRoute(
              navigatorKey: _shellNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _shellNavigatorKey,
                  path: '/home',
                  name: 'Home screen',
                  builder: (context, _) => sentimentanalysis(),
                ),
                GoRoute(
                  parentNavigatorKey: _shellNavigatorKey,
                  path: '/logout',
                  name: 'Log out',
                  builder: (context, _) => const logout(),
                ),
              ],
              builder: (context, state, child) {
                return homeWrapper(
                  child: child,
                );
              })
        ]);
  }
}
