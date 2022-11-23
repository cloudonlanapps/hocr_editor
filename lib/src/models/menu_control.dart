import 'dart:ui';

import 'package:dart_hocr/dart_hocr.dart';

enum ContentType {
  imageOnly,
  textOnly,
  imageAndText;

  String get name {
    switch (this) {
      case imageOnly:
        return "Image Only";

      case textOnly:
        return "Text Only";
      case imageAndText:
        return "Image + Text";
    }
  }
}

class MenuControl {
  final Size? imageSize;
  final Size? screenSize;

  final bool showColor;

  final bool fullMenu;
  final Offset menuPosition;
  final bool originalSize = false;
  final double zoomFactor;

  final ContentType contentType;
  final HOCRElementType boxType;

  MenuControl({
    required this.imageSize,
    required this.screenSize,
    this.showColor = false,
    this.fullMenu = false,
    this.menuPosition = const Offset(0, 500),
    //this.originalSize = false,
    this.zoomFactor = 2.0,
    this.contentType = ContentType.textOnly,
    this.boxType = HOCRElementType.none,
  });

  MenuControl copyWith({
    Size? imageSize,
    Size? screenSize,
    bool? showColor,
    bool? fullMenu,
    Offset? menuPosition,
    bool? originalSize,
    double? zoomFactor,
    ContentType? contentType,
    HOCRElementType? boxType,
  }) {
    return MenuControl(
      imageSize: imageSize ?? this.imageSize,
      screenSize: screenSize ?? this.screenSize,
      showColor: showColor ?? this.showColor,
      fullMenu: fullMenu ?? this.fullMenu,
      menuPosition: menuPosition ?? this.menuPosition,
      //originalSize: originalSize ?? this.originalSize,
      zoomFactor: zoomFactor ?? this.zoomFactor,
      contentType: contentType ?? this.contentType,
      boxType: boxType ?? this.boxType,
    );
  }

  double get scale {
    if (imageSize == null || screenSize == null) {
      return zoomFactor;
    }
    if (originalSize) return 1.0;
    double scale = zoomFactor * (screenSize!.width / imageSize!.width);

    return scale;
  }
}
