import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../providers/menu_control.dart';
import '../../../providers/ocr_image.dart';
import '../custom/cl_button.dart';
import 'box_type_menu.dart';
import 'content_type_menu.dart';
import 'zoom_menu.dart';

class Menu extends ConsumerWidget {
  final void Function() onDiscardImage;
  final void Function() onSaveImage;
  const Menu({
    Key? key,
    required this.onDiscardImage,
    required this.onSaveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(menuControlNotifierProvider);
    final OCRImage? ocrImage = ref.watch(ocrImageNotifierProvider);
    return Container(
      width: (uiState.screenSize?.width ?? MediaQuery.of(context).size.width) *
          0.6,
      decoration: BoxDecoration(
          color: CupertinoTheme.of(context).barBackgroundColor,
          //color: const Color.fromARGB(255, 255, 0, 0),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              //color: const Color.fromARGB(255, 255, 0, 10),
              ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(128 + 64, 128 + 64, 128 + 64, 128 + 64),
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                10.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ]),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CLIconButton.icon(
                      icon: Icon(
                        uiState.fullMenu
                            ? MdiIcons.arrowDown
                            : MdiIcons.arrowRight,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      onPressed: () => ref
                          .read(menuControlNotifierProvider.notifier)
                          .fullMenu = !uiState.fullMenu,
                    ),
                  ),
                  ZoomMenu(
                    onDiscardImage: onDiscardImage,
                    onSaveImage: onSaveImage,
                  )
                ],
              ),
              if (uiState.fullMenu) ...[
                /* const VerticalDivider(
                  thickness: 1,
                  color: Color.fromARGB(255, 128, 128, 128),
                ), */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (ocrImage?.image != null)
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: ContentTypeMenu(),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: BoxTypeMenu(),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  static Color iconColor(bool isDisabled) => isDisabled
      ? const Color.fromARGB(32, 32, 32, 32)
      : const Color.fromARGB(255, 0, 0, 0);
}
