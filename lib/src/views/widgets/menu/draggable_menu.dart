import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/menu_control.dart';

class DraggableMenu extends ConsumerWidget {
  final Widget child;
  const DraggableMenu(
      {Key? key,
      required GlobalKey<State<StatefulWidget>> parentKey,
      required this.child})
      : _parentKey = parentKey,
        super(key: key);

  final GlobalKey<State<StatefulWidget>> _parentKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuPosition = ref.watch(
        menuControlNotifierProvider.select((value) => value.menuPosition));
    return _DraggableMenu(
      parentKey: _parentKey,
      offset: menuPosition,
      onUpdateOffset: (offset) {
        ref.read(menuControlNotifierProvider.notifier).setMenuPosition(offset);
      },
      child: child,
    );
  }
}

class _DraggableMenu extends ConsumerStatefulWidget {
  final GlobalKey parentKey;
  final Widget child;
  final Offset offset;
  final void Function(Offset offset) onUpdateOffset;

  const _DraggableMenu(
      {Key? key,
      required this.parentKey,
      required this.child,
      required this.offset,
      required this.onUpdateOffset})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DraggableMenuState();
}

class DraggableMenuState extends ConsumerState<_DraggableMenu> {
  final GlobalKey _key = GlobalKey();

  bool _isDragging = false;

  late Offset _minOffset;
  late Offset _maxOffset;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_setBoundary);
  }

  void _setBoundary(_) {
    final RenderBox parentRenderBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    try {
      final Size parentSize = parentRenderBox.size;
      final Size size = renderBox.size;

      setState(() {
        _minOffset = const Offset(0, 0);
        _maxOffset = Offset(
            parentSize.width - size.width, parentSize.height - size.height);
      });
    } catch (e) {
      //print('catch: $e');

    }
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent, Offset currOffset) {
    final offset = currOffset;
    ref.read(menuControlNotifierProvider.select((value) => value.menuPosition));
    double newOffsetX = offset.dx + pointerMoveEvent.delta.dx;
    double newOffsetY = offset.dy + pointerMoveEvent.delta.dy;

    if (newOffsetX < _minOffset.dx) {
      newOffsetX = _minOffset.dx;
    } else if (newOffsetX > _maxOffset.dx) {
      newOffsetX = _maxOffset.dx;
    }

    if (newOffsetY < _minOffset.dy) {
      newOffsetY = _minOffset.dy;
    } else if (newOffsetY > _maxOffset.dy) {
      newOffsetY = _maxOffset.dy;
    }
    widget.onUpdateOffset(Offset(newOffsetX, newOffsetY));
  }

  @override
  Widget build(BuildContext context) {
    final offset = ref.watch(
        menuControlNotifierProvider.select((value) => value.menuPosition));

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Listener(
        onPointerMove: (PointerMoveEvent pointerMoveEvent) {
          _updatePosition(pointerMoveEvent, offset);

          setState(() {
            _isDragging = true;
          });
        },
        onPointerUp: (PointerUpEvent pointerUpEvent) {
          // print('onPointerUp');

          if (_isDragging) {
            setState(() {
              _isDragging = false;
            });
          } else {
            //widget.onPressed();
          }
        },
        child: Container(
          key: _key,
          margin: const EdgeInsets.all(4.0),
          child: widget.child,
        ),
      ),
    );
  }
}
