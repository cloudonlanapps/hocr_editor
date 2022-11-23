import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/menu_control.dart';

class BoxTypeMenu extends ConsumerWidget {
  const BoxTypeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxType =
        ref.watch(menuControlNotifierProvider.select((value) => value.boxType));

    return DropdownButton<HOCRElementType>(
      //underline: Container(height: 2),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black, // <-- SEE HERE
      ),
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black),
      borderRadius: BorderRadius.circular(8),
      alignment: Alignment.centerRight,
      dropdownColor: CupertinoTheme.of(context).barBackgroundColor,
      value: boxType,
      items: HOCRElementType.boxTypeSupported
          .map((e) => DropdownMenuItem<HOCRElementType>(
                value: e,
                child: Text(
                  e.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                ),
              ))
          .toList(),
      onChanged: (val) {
        if (val != null) {
          ref.read(menuControlNotifierProvider.notifier).boxType = val;
        }
      },
    );
  }
}
