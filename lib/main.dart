import 'dart:html' as html;

import 'main_public.dart' as pub;
import 'main_admin.dart' as admin;

void main() {
  final path = html.window.location.pathname;

  if (path.startsWith('/admin')) {
    admin.runAdminApp();
  } else {
    pub.runPublicApp();
  }
}
