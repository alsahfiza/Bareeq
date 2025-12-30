import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_route_provider.dart';
import '../routing/app_routes.dart';

class NavigationNotifier {
  static void go(
    BuildContext context,
    WidgetRef ref,
    String route,
  ) {
    ref.read(activeRouteProvider.notifier).state = route;

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.of(context).pushNamed(route);
    }
  }

  static void logout(BuildContext context, WidgetRef ref) {
    ref.read(activeRouteProvider.notifier).state = AppRoutes.login;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }
}
