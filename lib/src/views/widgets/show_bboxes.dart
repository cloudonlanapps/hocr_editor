import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/menu_control.dart';
import '../../providers/ocr_doc.dart';

class ShowBBoxes extends ConsumerWidget {
  const ShowBBoxes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HOCRDoc?> asyncHOCRDoc = ref.watch(ocrDataProvider);

    return asyncHOCRDoc.maybeWhen(
        data: (HOCRDoc? doc) =>
            (doc == null) ? Container() : _ShowBBoxes(doc: doc),
        // Supress this layer when loading and on error
        orElse: () => Container());
  }
}

class _ShowBBoxes extends ConsumerWidget {
  final HOCRDoc doc;

  const _ShowBBoxes({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double scale =
        ref.watch(menuControlNotifierProvider.select((value) => value.scale));
    final boxType =
        ref.watch(menuControlNotifierProvider.select((value) => value.boxType));

    return Stack(
      children: [
        for (final node in doc.getNodes(boxType))
          Positioned.fromRect(
            rect: Rect.fromLTRB(node.ltrb2.l * scale, node.ltrb2.t * scale,
                node.ltrb2.r * scale, node.ltrb2.b * scale),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                    color: node.disabled
                        ? const Color.fromARGB(255, 255, 32, 32)
                        : const Color.fromARGB(255, 32, 255, 32)),
              ),
            ),
          )
      ],
    );
  }

  Rect rect({required List<double> ltrb, required double scale}) =>
      Rect.fromLTRB(
          ltrb[0] * scale, ltrb[1] * scale, ltrb[2] * scale, ltrb[3] * scale);
}
