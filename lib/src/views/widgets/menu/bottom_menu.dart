import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hocr_editor/src/views/widgets/custom/cl_cust_menu_row.dart';

import '../../../providers/ocr_doc.dart';
import '../../../providers/ocr_image.dart';
import '../../hocr_editing_controller.dart';
import '../custom/cl_cust_menu_item.dart';
import '../custom/cl_fullscreen_box.dart';

class BottomMenu extends ConsumerWidget {
  final HOCREditingController ocrViewController;
  const BottomMenu({super.key, required this.ocrViewController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HOCRDoc?> asyncHOCRDoc = ref.watch(ocrDataProvider);

    return asyncHOCRDoc.maybeWhen(
        data: (HOCRDoc? doc) => (doc == null)
            ? Container()
            : _BottomMenu(ocrViewController: ocrViewController, doc: doc),
        // Supress this layer when loading and on error
        orElse: () => Container());
  }
}

class _BottomMenu extends ConsumerStatefulWidget {
  final HOCREditingController ocrViewController;
  final HOCRDoc doc;
  const _BottomMenu(
      {Key? key, required this.ocrViewController, required this.doc})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BottomMenuState();
}

class BottomMenuState extends ConsumerState<_BottomMenu> {
  @override
  Widget build(BuildContext context) {
    final OCRImage? ocrImage = ref.watch(ocrImageNotifierProvider);

    bool hasId = ocrImage?.hasId ?? false;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).selectedRowColor,
          //color: const Color.fromARGB(255, 255, 0, 0),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(CLFullscreenBox.borderRadius),
              bottomRight: Radius.circular(CLFullscreenBox.borderRadius)),
        ),
        child: Center(
          child: CLCustMenuRow(
            menuItems: [
              CLCustomMenuItem(
                  label: 'Copy All',
                  icon: FontAwesomeIcons.copy,
                  onTap: onCopyAll,
                  scale: 0.8),
              CLCustomMenuItem(
                  label: 'Translate',
                  icon: FontAwesomeIcons.globe,
                  onTap: onTranslate,
                  scale: 0.8),
              if (widget.ocrViewController.edit)
                CLCustomMenuItem(
                    label: hasId
                        ? (widget.doc.isChanged ? 'Update' : 'Saved')
                        : 'Save',
                    icon: hasId
                        ? (widget.doc.isChanged
                            ? FontAwesomeIcons.circlePlus
                            : FontAwesomeIcons.check)
                        : FontAwesomeIcons.circlePlus,
                    onTap:
                        hasId ? (widget.doc.isChanged ? onSave : null) : onSave,
                    scale: 0.8),
              CLCustomMenuItem(
                label: hasId ? "Close" : 'Discard Image',
                icon: hasId
                    ? FontAwesomeIcons.solidRectangleXmark
                    : FontAwesomeIcons.solidTrashCan,
                onTap: onClose,
                scale: 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onCopyAll() {
    widget.ocrViewController.onCopyToClipboard?.call(widget.doc.getText());
  }

  onTranslate() => widget.ocrViewController.onDictLookup?.call(
      widget.doc.getText(),
      lang:
          ref.watch(ocrImageNotifierProvider.select((value) => value!.lang1)));

  onSave() async {
    final OCRImage? ocrImage = ref.read(ocrImageNotifierProvider);
    OCRImage? savedOCRImage = await widget.ocrViewController.onSaveImage
        ?.call(ocrImage!.copyWith(xml: widget.doc.xmlDocument.toXmlString()));
    if (mounted && (savedOCRImage != null)) {
      ref.read(ocrImageNotifierProvider.notifier).newOCRImage = savedOCRImage;
    }
  }

  onClose() async {
    bool hasId = ref.watch(
        ocrImageNotifierProvider.select((value) => value?.hasId ?? false));
    if (!hasId || widget.doc.isChanged) {
      final result = await showOkCancelAlertDialog(
        context: context,
        message: hasId
            ? "Do you want to discard your changes and close?"
            : 'Are you sure that you want to delete this story?',
        okLabel: "Yes",
        cancelLabel: "No",
      );
      if (result == OkCancelResult.cancel) {
        return;
      }
    }
    if (mounted) {
      widget.ocrViewController.onDiscardImage?.call();
    }
  }
}
