import 'package:flutter/material.dart';

class CLCustomMenuItem {
  String? label;
  IconData? icon;
  final AlignmentGeometry alignment;
  void Function()? onTap;
  void Function()? onLongPress;
  double? scale;
  Color color;
  TextStyle textStyle;
  CLCustomMenuItem(
      {this.label,
      this.icon,
      Color? color,
      TextStyle? textStyle,
      this.onTap,
      this.alignment = Alignment.center,
      this.onLongPress,
      this.scale})
      : textStyle = textStyle ??
            TextStyle(
                color: onTap == null ? Colors.grey.shade300 : Colors.black),
        color = color ?? (onTap == null ? Colors.grey.shade300 : Colors.black) {
    if (icon == null && label == null) {
      throw Exception("Either icon or label must be provided.");
    }
  }
}
