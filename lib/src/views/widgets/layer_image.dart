import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/image_extension.dart';
import '../../providers/ocr_image.dart';

class LayerImage extends ConsumerWidget {
  const LayerImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrImage = ref.watch(ocrImageNotifierProvider);
    if (ocrImage?.image == null) return Container();

    final AsyncValue<ui.Image?> uiImageAsync =
        ref.watch(uiImageProvider(ocrImage?.image));

    return uiImageAsync.maybeWhen(
        orElse: () => Container(),
        data: (uiImage) => SizedBox.expand(
            child: FittedBox(
                fit: BoxFit.contain, child: RawImage(image: uiImage))));
  }
}
