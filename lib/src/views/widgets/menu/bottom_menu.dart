import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../providers/ocr_doc.dart';
import '../../../providers/ocr_image.dart';
import '../../hocr_editing_controller.dart';
import '../custom/cl_fullscreen_box.dart';
import '../custom/cl_popup.dart';

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
    String? lang = (ocrImage?.lang1)!;
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                CLMenuItem('Copy All', FontAwesomeIcons.copy, onTap: () {
                  widget.ocrViewController.onCopyToClipboard
                      ?.call(widget.doc.getText());
                }),
                CLMenuItem('Translate', FontAwesomeIcons.globe,
                    onTap: () => widget.ocrViewController.onDictLookup
                        ?.call(widget.doc.getText(), lang: lang)),
                if (widget.ocrViewController.edit) ...[
                  /* if (!hasId)
                    CLMenuItem('Accept Changes', FontAwesomeIcons.check,
                        onTap: () {}), */
                  /* CLMenuItem('Update Story', Icons.save_alt,
                    onTap: () {}), */
                  if (hasId)
                    if (widget.doc.isChanged)
                      CLMenuItem('Update Story', FontAwesomeIcons.circlePlus,
                          onTap: onSave)
                    else
                      CLMenuItem('Saved', FontAwesomeIcons.check, onTap: null)
                  else
                    CLMenuItem('Add to Stories', FontAwesomeIcons.circlePlus,
                        onTap: onSave),
                ],
                CLMenuItem(
                    hasId ? "Close" : 'Discard Image',
                    hasId
                        ? FontAwesomeIcons.solidRectangleXmark
                        : FontAwesomeIcons.solidTrashCan, onTap: () async {
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
                }),
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: CLPopupMenuItem(
                            menuItem: e,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )),
    );
  }

  onSave() async {
    final OCRImage? ocrImage = ref.read(ocrImageNotifierProvider);
    OCRImage? savedOCRImage = await widget.ocrViewController.onSaveImage
        ?.call(ocrImage!.copyWith(xml: widget.doc.xmlDocument.toXmlString()));
    if (mounted && (savedOCRImage != null)) {
      ref.read(ocrImageNotifierProvider.notifier).newOCRImage = savedOCRImage;
    }
  }
}
