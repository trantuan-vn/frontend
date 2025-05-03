// web_view_registry.dart
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;

typedef ViewFactory = ui.PlatformViewFactory;

void registerViewFactory(String viewId, ViewFactory viewFactory) {
  ui.platformViewRegistry.registerViewFactory(viewId, viewFactory);
}
