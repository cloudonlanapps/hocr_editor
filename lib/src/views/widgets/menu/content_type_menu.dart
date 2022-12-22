import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/menu_control.dart';
import '../../../providers/menu_control.dart';

// TODO(anandas): Remove content type
class ContentTypeMenu extends ConsumerWidget {
  const ContentTypeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalSize = ref.watch(
        menuControlNotifierProvider.select((value) => value.originalSize));
    final contentType = ref.watch(
        menuControlNotifierProvider.select((value) => value.contentType));
    return DropdownButton<ContentType>(
      borderRadius: BorderRadius.circular(8),
      alignment: Alignment.centerRight,
      value: contentType,
      items: ContentType.values
          //.where((element) => element != ContentType.imageAndText)
          .map((e) => DropdownMenuItem<ContentType>(
                value: e,
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (val) {
        if (val != null) {
          if (val == ContentType.imageAndText && originalSize) {
            // You can't change, notify with snackbar?
            return;
          }

          ref.read(menuControlNotifierProvider.notifier).contentType = val;
        }
      },
    );
  }
}
