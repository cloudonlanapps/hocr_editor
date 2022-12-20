import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../providers/ocr_doc.dart';
import '../../../providers/ocr_image.dart';
import '../../../providers/pop_menu_control.dart';
import '../../hocr_editing_controller.dart';
import '../custom/cl_popup.dart';

class PopupMenu extends ConsumerWidget {
  final HOCREditingController ocrViewController;
  final Function(String id, String text)? onEdit;
  const PopupMenu({
    super.key,
    required this.ocrViewController,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final control = ref.watch(popMenuControlNotifierProvider);
    final OCRImage? ocrImage = ref.watch(ocrImageNotifierProvider);
    if (!control.isMenuShowing) return Container();
    String? lang = (ocrImage?.lang1)!;
    final menuItems = [
      CLMenuItemOld('Copy', Icons.content_copy,
          onTap: (control.node!.disabled ||
                  ocrViewController.onCopyToClipboard == null)
              ? null
              : () =>
                  ocrViewController.onCopyToClipboard!(control.node!.word!)),
      CLMenuItemOld('Dictionary', Icons.translate,
          onTap:
              (control.node!.disabled || ocrViewController.onDictLookup == null)
                  ? null
                  : () async {
                      await ocrViewController.onDictLookup!(control.node!.word!,
                          lang: lang);
                      //ref.read(popMenuControlNotifierProvider.notifier).hideMenu();
                    }),
      if (ocrViewController.edit) ...[
        if (control.node!.disabled)
          CLMenuItemOld("Undo", FontAwesomeIcons.arrowRotateLeft,
              onTap: () => onDelete(ref))
        else
          CLMenuItemOld('Delete', FontAwesomeIcons.textSlash,
              onTap: () => onDelete(ref)),
        if (!control.node!.disabled)
          CLMenuItemOld('Edit', Icons.edit,
              onTap: control.node!.disabled
                  ? null
                  : () =>
                      onEdit?.call(control.node!.id, control.node!.word ?? "")),
      ],
      if (control.node!.replacedText != null)
        CLMenuItemOld('Restore', Icons.restore, onTap: () => restoreText(ref)),
    ];
    if (!control.isMenuShowing) {
      return Container();
    }

    return CLShowPopup(
      region: control.region,
      anchorOffset: control.anchorOffset!,
      anchorSize: control.anchorSize!,
      title: control.node!.word,
      children: [
        ...menuItems.map((item) => CLPopupMenuItem(menuItem: item)).toList()
      ],
      // ,
      onHideMenu: () =>
          ref.read(popMenuControlNotifierProvider.notifier).hideMenu(),
    );
  }

  restoreText(WidgetRef ref) {
    final control = ref.watch(popMenuControlNotifierProvider);
    if (control.node!.replacedText != null) {
      ref
          .read(ocrDataProvider.notifier)
          .replaceText(control.node!.id, control.node!.originalWord!);
    }
    ref.read(popMenuControlNotifierProvider.notifier).hideMenu();
  }

  onDelete(WidgetRef ref) {
    final control = ref.watch(popMenuControlNotifierProvider);
    ref.read(ocrDataProvider.notifier).toggleDisable(control.node!.id);
    ref.read(popMenuControlNotifierProvider.notifier).hideMenu();
  }
}
