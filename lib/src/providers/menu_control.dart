import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/menu_control.dart';

class MenuControlNotifier extends StateNotifier<MenuControl> {
  Size? imageSize;
  Size? screenSize;
  MenuControlNotifier({
    this.imageSize,
    this.screenSize,
  }) : super(MenuControl(
          imageSize: imageSize,
          screenSize: screenSize,
        ));

  setMenuPosition(Offset pos) {
    state = state.copyWith(menuPosition: pos);
  }

  set fullMenu(bool val) => state = state.copyWith(fullMenu: val);
  set originalSize(bool val) =>
      state = state.copyWith(originalSize: val, zoomFactor: val ? null : 1.0);
  set zoomFactor(double val) => state = state.copyWith(zoomFactor: val);
  set contentType(ContentType val) => state = state.copyWith(contentType: val);
  set boxType(HOCRElementType val) => state = state.copyWith(boxType: val);
}

final menuControlNotifierProvider =
    StateNotifierProvider<MenuControlNotifier, MenuControl>((ref) {
  throw Exception("You must  override menuControlNotifierProvider to use");
});
