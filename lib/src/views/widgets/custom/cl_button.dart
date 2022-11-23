import 'package:flutter/cupertino.dart';

class CLIconButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;

  const CLIconButton(
      {Key? key, required this.child, this.onPressed, this.color})
      : super(key: key);

  const CLIconButton.icon(
      {Key? key, required Icon icon, this.onPressed, this.color})
      : child = icon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      color: color,
      padding: EdgeInsets.zero,
      child: child,
    );
  }
}
