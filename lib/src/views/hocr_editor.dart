// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:dart_hocr/dart_hocr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/menu_control.dart';
import '../models/pop_menu_control.dart';
import '../providers/menu_control.dart';
import '../providers/ocr_doc.dart';
import '../providers/ocr_image.dart';
import '../providers/pop_menu_control.dart';
import 'hocr_editing_controller.dart';
import 'widgets/custom/cl_fullscreen_box.dart';
import 'widgets/layer_image.dart';
import 'widgets/menu/bottom_menu.dart';
import 'widgets/menu/draggable_menu.dart';
import 'widgets/menu/menu.dart';
import 'widgets/menu/popup_menu.dart';
import 'widgets/scrollable_stack.dart';
import 'widgets/show_bboxes.dart';
import 'widgets/show_text.dart';

class HOCREditor extends StatelessWidget {
  final HOCREditingController? ocrViewController;
  final OCRImage ocrImage;
  const HOCREditor({Key? key, required this.ocrImage, this.ocrViewController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = CLFullscreenBox.size(context);
    return CLFullscreenBox(
        child: LayoutBuilder(
            builder: (context, constrain) => ProviderScope(
                    overrides: [
                      menuControlNotifierProvider.overrideWithProvider(
                          StateNotifierProvider<MenuControlNotifier,
                              MenuControl>((ref) {
                        return MenuControlNotifier();
                      })),
                      popMenuControlNotifierProvider.overrideWithProvider(
                          StateNotifierProvider<PopMenuControlNotifier,
                              PopMenuControl>((ref) {
                        return PopMenuControlNotifier();
                      })),
                      ocrImageNotifierProvider.overrideWithProvider(
                          StateNotifierProvider.autoDispose<OCRImageNotifier,
                              OCRImage?>((ref) {
                        return OCRImageNotifier(ocrImage: ocrImage);
                      })),
                      menuControlNotifierProvider.overrideWithProvider(
                          StateNotifierProvider<MenuControlNotifier,
                              MenuControl>((ref) {
                        return MenuControlNotifier(
                            imageSize: Size(ocrImage.width, ocrImage.height),
                            screenSize:
                                Size(screenSize.width, screenSize.height));
                      }))
                    ],
                    child: _HOCRViewer(
                        ocrViewController: ocrViewController ??
                            HOCREditingController()) //_HOCRViewer(ocrViewController: ocrViewController),
                    )));
  }
}

class _HOCRViewer extends ConsumerStatefulWidget {
  final HOCREditingController ocrViewController;

  const _HOCRViewer({Key? key, required this.ocrViewController})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __HOCRViewerState();
}

class __HOCRViewerState extends ConsumerState<_HOCRViewer> {
  final GlobalKey parentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final fullMenu = ref
        .watch(menuControlNotifierProvider.select((value) => value.fullMenu));
    final contentType = ref.watch(
        menuControlNotifierProvider.select((value) => value.contentType));
    final popMenu = ref.watch(
        popMenuControlNotifierProvider.select((value) => value.isMenuShowing));
    //final controller = ref.watch(popMenuControlNotifierProvider);
    //print(controller);
    final ocrImage = ref.watch(ocrImageNotifierProvider);
    return Stack(
      key: parentKey,
      children: [
        SafeArea(
          child: Column(
            children: [
              Flexible(
                flex: 10,
                child: ScrollableStack(
                  children: [
                    if (contentType != ContentType.textOnly) const LayerImage(),
                    if (contentType != ContentType.imageOnly) const ShowWords(),
                    const IgnorePointer(child: ShowBBoxes()),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox.expand(
                    child:
                        BottomMenu(ocrViewController: widget.ocrViewController),
                  ))
            ],
          ),
        ),
        DraggableMenu(
          key: ValueKey("DraggableMenu_$fullMenu"),
          parentKey: parentKey,
          child: Menu(
            onDiscardImage: () =>
                widget.ocrViewController.onDiscardImage?.call(),
            onSaveImage: () =>
                widget.ocrViewController.onSaveImage?.call(ocrImage!),
          ),
        ),
        if (popMenu && widget.ocrViewController.edit)
          PopupMenu(
            ocrViewController: widget.ocrViewController,
            onEdit: updateText,
          )
      ],
    );
  }

  updateText(String id, String word) async {
    ref.read(popMenuControlNotifierProvider.notifier).hideMenu();
    final text = await showTextInputDialog(
        title: "Edit the word",
        message: word,
        context: context,
        textFields: [DialogTextField(initialText: word)]);
    if (text?.isNotEmpty ?? false) {
      if (text != null && text[0] != word) {
        ref.read(ocrDataProvider.notifier).replaceText(id, text[0]);
      }
    }
  }
}
