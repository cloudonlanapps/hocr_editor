import 'package:flutter/material.dart';

class CLFullscreenBox extends StatelessWidget {
  final Widget child;
  static const double marginLeft = 4;
  static const double marginTop = 4;
  static const double marginRight = 4;
  static const double marginBottom = 8;

  static const double borderRadius = 15;
  const CLFullscreenBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRect(
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(
              left: marginLeft,
              right: marginRight,
              top: marginTop,
              bottom: marginBottom),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: SizedBox.fromSize(size: size(context), child: child),
        ),
      ),
    ));
  }

  static Size size(context) => Size(
        MediaQuery.of(context).size.width - marginLeft - marginRight,
        MediaQuery.of(context).size.height - marginTop + -marginBottom,
      );
}
