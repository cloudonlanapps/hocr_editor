import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/menu_control.dart';
import 'custom/cl_scrollable.dart';

class ScrollableStack extends ConsumerWidget {
  final ScrollController? controllerH;
  final ScrollController? controllerV;

  final List<Widget> children;
  const ScrollableStack(
      {Key? key, required this.children, this.controllerH, this.controllerV})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size imgSize = ref
        .watch(menuControlNotifierProvider.select((value) => value.imageSize!));
    double scale =
        ref.watch(menuControlNotifierProvider.select((value) => value.scale));
    return CLScrollable(
      key: ValueKey(scale),
      childWidth: imgSize.width * scale,
      childHeight: imgSize.height * scale,
      child: Stack(
        children: children,
      ),
    );
  }
}
