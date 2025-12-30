import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/active_route_provider.dart';

class ActiveRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final Ref ref;

  ActiveRouteObserver(this.ref);

  @override
  void didPush(Route route, Route? previousRoute) {
    _update(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) _update(previousRoute);
  }

  void _update(Route route) {
    final name = route.settings.name;
    if (name != null) {
      ref.read(activeRouteProvider.notifier).state = name;
    }
  }
}
