import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;

const _key = 'sidebar_collapsed';

final sidebarCollapsedProvider =
    StateNotifierProvider<SidebarCollapsedNotifier, bool>(
  (ref) => SidebarCollapsedNotifier(),
);

class SidebarCollapsedNotifier extends StateNotifier<bool> {
  SidebarCollapsedNotifier() : super(_load());

  static bool _load() {
    final value = html.window.localStorage[_key];
    return value == 'true';
  }

  void toggle() {
    state = !state;
    html.window.localStorage[_key] = state.toString();
  }

  void set(bool value) {
    state = value;
    html.window.localStorage[_key] = value.toString();
  }
}
