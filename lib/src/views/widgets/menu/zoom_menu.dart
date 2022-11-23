import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../providers/menu_control.dart';

import '../custom/cl_button.dart';
import 'menu.dart';

class ZoomMenu extends ConsumerWidget {
  final void Function() onDiscardImage;
  final void Function() onSaveImage;
  const ZoomMenu({
    Key? key,
    required this.onDiscardImage,
    required this.onSaveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalSize = ref.watch(
        menuControlNotifierProvider.select((value) => value.originalSize));
    final zoomFactor = ref
        .watch(menuControlNotifierProvider.select((value) => value.zoomFactor));

    return Row(children: [
      CLIconButton.icon(
        icon: Icon(
          MdiIcons.magnifyMinusOutline,
          color: Menu.iconColor((!(!originalSize && zoomFactor > 1))),
        ),
        onPressed: (!originalSize && zoomFactor > 1)
            ? () => ref.read(menuControlNotifierProvider.notifier).zoomFactor =
                zoomFactor - 1
            : null,
      ),
      CLIconButton.icon(
        icon: Icon(MdiIcons.arrowCollapseAll,
            color: Menu.iconColor(!(zoomFactor > 1.0))),
        onPressed: (zoomFactor > 1.0)
            ? () =>
                ref.read(menuControlNotifierProvider.notifier).zoomFactor = 1.0
            : null,
      ),
      CLIconButton.icon(
        icon: Icon(
          MdiIcons.magnifyPlusOutline,
          color: Menu.iconColor(!((!originalSize && zoomFactor < 4))),
        ),
        onPressed: (!originalSize && zoomFactor < 4)
            ? () => ref.read(menuControlNotifierProvider.notifier).zoomFactor =
                zoomFactor + 1
            : null,
      ),

      /* 

       Text(originalSize ? "Full\nSize" : "${zoomFactor}x"),

       final contentType = ref.watch(
        menuControlNotifierProvider.select((value) => value.contentType));
      CLIconButton.icon(
        icon: Icon(
          MdiIcons.arrowExpandAll,
          color: Menu.iconColor(originalSize),
        ),
        onPressed: !originalSize && contentType != ContentType.imageAndText
            ? () => ref
                .read(menuControlNotifierProvider.notifier)
                .originalSize = true
            : null,
      ), */
    ]);
  }
}
