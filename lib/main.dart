import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runApp(MyApp());
}

class ConnectivityOverlay {
  static final ConnectivityOverlay _singleton = ConnectivityOverlay._internal();

  factory ConnectivityOverlay() {
    return _singleton;
  }

  ConnectivityOverlay._internal();

  static OverlayEntry overlayEntry;

  void showOverlay(BuildContext context, Widget child) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (context) => child);
    }
     var overlayState = Overlay.of(context);
    overlayState.insert(overlayEntry);
  }

  void removeOverlay(BuildContext context) {
    overlayEntry?.remove();
  }
}
