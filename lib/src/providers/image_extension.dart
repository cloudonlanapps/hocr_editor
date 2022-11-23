import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_extension.dart';

final uiImageProvider = FutureProvider.family
    .autoDispose<ui.Image?, img.Image?>(
        (ref, imgImage) async => await imgImage?.toUiImage());
