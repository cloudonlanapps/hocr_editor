import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PressType {
  longPress,
  singleClick,
}

enum PreferredPosition {
  top,
  bottom,
}

Rect _menuRect = Rect.zero;

class CLShowPopup extends StatefulWidget {
  final double horizontalMargin;
  final double verticalMargin;
  final bool enablePassEvent;
  final PreferredPosition? position;
  final Color barrierColor;
  final String? title;
  final List<Widget> children;
  final Size? region;
  final Offset anchorOffset;
  final Size anchorSize;
  final void Function() onHideMenu;

  const CLShowPopup(
      {super.key,
      this.horizontalMargin = 0.0,
      this.verticalMargin = 0.0,
      this.enablePassEvent = true,
      this.position,
      this.barrierColor = Colors.transparent, //Colors.black12,
      this.title,
      required this.children,
      this.region,
      required this.anchorOffset,
      required this.anchorSize,
      required this.onHideMenu});

  @override
  State<StatefulWidget> createState() => _MenuWrapperState();
}

class _MenuWrapperState extends State<CLShowPopup> {
  bool _canResponse = true;

  @override
  Widget build(BuildContext context) {
    Widget menu = Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              (widget.region?.width ?? MediaQuery.of(context).size.width) -
                  2 * widget.horizontalMargin,
          minWidth: 0,
        ),
        child: CustomMultiChildLayout(
          delegate: _MenuLayoutDelegate(
            anchorSize: widget.anchorSize,
            anchorOffset: widget.anchorOffset,
            verticalMargin: widget.verticalMargin,
            position: widget.position,
          ),
          children: <Widget>[
            LayoutId(
                id: _MenuLayoutId.content,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 3 / 5,
                        decoration: BoxDecoration(
                          color: CupertinoTheme.of(context)
                              .barBackgroundColor
                              .withOpacity(1.0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            if (widget.title != null)
                              Text(
                                (widget.title)!,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            if (widget.children.length == 1)
                              ...widget.children
                            else
                              GridView.count(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                crossAxisCount: 4,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: widget.children,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
    return Listener(
      behavior: widget.enablePassEvent
          ? HitTestBehavior.translucent
          : HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) {
        Offset offset = event.localPosition;
        // If tap position in menu
        if (_menuRect
            .contains(Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
          return;
        }
        if (!_canResponse) return;
        widget.onHideMenu();

        // When [enablePassEvent] works and we tap the [child] to [hideMenu],
        // but the passed event would trigger [showMenu] again.
        // So, we use time threshold to solve this bug.
        _canResponse = false;
        Future.delayed(const Duration(milliseconds: 300))
            .then((_) => _canResponse = true);
      },
      child: widget.barrierColor == Colors.transparent
          ? menu
          : Container(
              color: widget.barrierColor,
              child: menu,
            ),
    );
  }
}

enum _MenuLayoutId { content }

enum _MenuPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
    this.position,
  });

  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;
  final PreferredPosition? position;

  @override
  void performLayout(Size size) {
    // Validate if this hardcodign makes sense

    Size contentSize = Size.zero;

    Offset contentOffset = const Offset(0, 0);

    double anchorCenterX = anchorOffset.dx;

    double anchorTopY = anchorOffset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;

    _MenuPosition menuPosition = _MenuPosition.bottomCenter;

    if (hasChild(_MenuLayoutId.content)) {
      contentSize = layoutChild(
        _MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }

    bool isTop = false;
    if (position == null) {
      // auto calculate position
      isTop = anchorBottomY > size.height / 2;
    } else {
      isTop = position == PreferredPosition.top;
    }
    if (anchorCenterX - contentSize.width / 2 < 0) {
      menuPosition = isTop ? _MenuPosition.topLeft : _MenuPosition.bottomLeft;
    } else if (anchorCenterX + contentSize.width / 2 > size.width) {
      menuPosition = isTop ? _MenuPosition.topRight : _MenuPosition.bottomRight;
    } else {
      menuPosition =
          isTop ? _MenuPosition.topCenter : _MenuPosition.bottomCenter;
    }

    // ignore: todo
    ///  TODO: Find why we need this offset, this was found in trial and error
    /// on iPhone X
    double menuOffset = -48;
    switch (menuPosition) {
      case _MenuPosition.bottomCenter:
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorBottomY + verticalMargin + menuOffset,
        );
        break;
      case _MenuPosition.bottomLeft:
        contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin + menuOffset,
        );
        break;
      case _MenuPosition.bottomRight:
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorBottomY + verticalMargin + menuOffset,
        );
        break;
      case _MenuPosition.topCenter:
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorTopY - verticalMargin - contentSize.height + menuOffset,
        );
        break;
      case _MenuPosition.topLeft:
        contentOffset = Offset(
          0,
          anchorTopY - verticalMargin - contentSize.height + menuOffset,
        );
        break;
      case _MenuPosition.topRight:
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorTopY - verticalMargin - contentSize.height + menuOffset,
        );
        break;
    }
    if (hasChild(_MenuLayoutId.content)) {
      positionChild(_MenuLayoutId.content, contentOffset);
    }

    _menuRect = Rect.fromLTWH(
      contentOffset.dx,
      contentOffset.dy,
      contentSize.width,
      contentSize.height,
    );
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

class CLMenuItem {
  String title;
  IconData icon;
  void Function()? onTap;
  CLMenuItem(this.title, this.icon, {this.onTap});
}

class CLPopupMenuItem extends StatelessWidget {
  final CLMenuItem menuItem;
  const CLPopupMenuItem({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color.fromARGB(128, 255, 0, 0),
      onTap: menuItem.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            menuItem.icon,
            size: 20,
            color: menuItem.onTap == null ? Colors.grey.shade300 : Colors.black,
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(
              menuItem.title,
              style: TextStyle(
                  color: menuItem.onTap == null
                      ? Colors.grey.shade300
                      : Colors.black,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
