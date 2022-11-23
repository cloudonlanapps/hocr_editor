import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/menu_control.dart';
import '../../providers/ocr_doc.dart';
import 'interactive_text.dart';

class ShowWords extends ConsumerWidget {
  const ShowWords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HOCRDoc?> asyncHOCRDoc = ref.watch(ocrDataProvider);

    return asyncHOCRDoc.maybeWhen(
        data: (HOCRDoc? doc) =>
            (doc == null) ? Container() : _ShowWords(doc: doc),
        // Supress this layer when loading and on error
        orElse: () => Container());
  }
}

class _ShowWords extends ConsumerWidget {
  final HOCRDoc doc;
  const _ShowWords({Key? key, required this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double scale =
        ref.watch(menuControlNotifierProvider.select((value) => value.scale));
    return Stack(
      children: [
        for (final HOCRNode node in doc.wordNodes)
          if (node.word != null)
            Positioned.fromRect(
              rect: Rect.fromLTRB(node.ltrb2.l * scale, node.ltrb2.t * scale,
                  node.ltrb2.r * scale, node.ltrb2.b * scale),
              child: InteractiveWord(node: node),
            )
      ],
    );
  }
}
