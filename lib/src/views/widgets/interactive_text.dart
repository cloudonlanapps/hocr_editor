// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dart_hocr/dart_hocr.dart';
import '../../providers/pop_menu_control.dart';

class InteractiveWord extends ConsumerStatefulWidget {
  const InteractiveWord({super.key, required this.node});
  final HOCRNode node;

  @override
  ConsumerState<InteractiveWord> createState() => InteractiveWordState();
}

class InteractiveWordState extends ConsumerState<InteractiveWord> {
  Size? parentSize;
  Size? anchorSize;
  Offset? anchorOffset;

  @override
  Widget build(BuildContext context) {
    final control = ref.watch(popMenuControlNotifierProvider);
    final isMenuShowing = control.isMenuShowing && control.node == widget.node;

    return GestureDetector(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Text(widget.node.word!,
                    style: textStyle(isMenuShowing: isMenuShowing))),
          ),
        ),
        onTapDown: (TapDownDetails details) {
          RenderBox? parentBox =
              Overlay.of(context)?.context.findRenderObject() as RenderBox?;
          RenderBox? childBox = context.findRenderObject() as RenderBox?;
          anchorSize = childBox!.size;
          anchorOffset = childBox.localToGlobal(const Offset(0, 0));

          parentSize = parentBox?.size;
        },
        onTap: () {
          if (anchorOffset == null || anchorSize == null) {
            /// we can't do anything as we couldn't identify the rectangle
            /// that was pressed
            return;
          }

          ref.read(popMenuControlNotifierProvider.notifier).showMenu(
              region: parentSize,
              anchorSize: anchorSize!,
              anchorOffset: anchorOffset!,
              node: widget.node);
        });
  }

  TextStyle? textStyle({required bool isMenuShowing}) {
    TextStyle style = Theme.of(context).textTheme.bodyLarge!;

    if (widget.node.disabled) {
      style = style.copyWith(
          color: Colors.red.shade400, decoration: TextDecoration.lineThrough);
    }
    if (widget.node.replacedText != null) {
      style = style.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
          decoration: TextDecoration.underline);
    }
    if (isMenuShowing) {
      style = style.copyWith(backgroundColor: Colors.yellowAccent.shade200);
    }
    return style;
  }
}
