// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dart_hocr/dart_hocr.dart';
import 'package:flutter/widgets.dart';

class ItemModel {
  String title;
  IconData icon;
  void Function()? action;
  ItemModel(this.title, this.icon, {this.action});
}

class PopMenuControl {
  final bool isMenuShowing;
  final Size? region;
  final Size? anchorSize;
  final Offset? anchorOffset;
  final HOCRNode? node;
  final bool edit;

  PopMenuControl({
    this.isMenuShowing = false,
    this.region,
    this.anchorSize,
    this.anchorOffset,
    this.node,
    this.edit = false,
  }) {
    //print(bBox?.id);
  }
  PopMenuControl copyWith(
      {bool? isMenuShowing,
      Size? region,
      Size? anchorSize,
      Offset? anchorOffset,
      HOCRNode? node,
      bool? edit}) {
    return PopMenuControl(
        isMenuShowing: isMenuShowing ?? this.isMenuShowing,
        region: region ?? this.region,
        anchorSize: anchorSize ?? this.anchorSize,
        anchorOffset: anchorOffset ?? this.anchorOffset,
        node: node ?? this.node,
        edit: edit ?? this.edit);
  }

  PopMenuControl showMenu(
      {Size? region,
      required Size anchorSize,
      required Offset anchorOffset,
      required HOCRNode node}) {
    return copyWith(
        region: region,
        anchorSize: anchorSize,
        anchorOffset: anchorOffset,
        node: node,
        isMenuShowing: true);
  }

  PopMenuControl hideMenu() => copyWith(
        region: null,
        anchorSize: null,
        anchorOffset: null,
        isMenuShowing: false,
      );

  PopMenuControl editText(bool enable) => copyWith(
        edit: enable,
      );

  @override
  String toString() {
    return 'PopMenuControl(isMenuShowing: $isMenuShowing, region: $region, '
        'anchorSize: $anchorSize, anchorOffset: $anchorOffset, '
        'node: $node, edit: $edit)';
  }
}
