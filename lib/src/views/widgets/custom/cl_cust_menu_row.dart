import 'package:flutter/material.dart';

import 'cl_cust_menu_item.dart';

class CLCustMenuRowButton extends StatelessWidget {
  final CLCustomMenuItem menuItem;

  const CLCustMenuRowButton({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    TextStyle menuIconStyle = menuItem.textStyle;
    final color = menuItem.onTap == null ? Colors.grey : menuItem.color;
    return Transform.scale(
      scale: menuItem.scale ?? 1.0,
      child: InkWell(
        //splashColor: const Color.fromARGB(128, 255, 0, 0),
        onTap: menuItem.onTap,
        onLongPress: menuItem.onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (menuItem.icon != null)
              Flexible(
                  child: FittedBox(
                      child: Icon(menuItem.icon!, size: 40, color: color))),
            if (menuItem.label != null)
              Flexible(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      menuItem.label!,
                      style: menuIconStyle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CLCustMenuRow extends StatelessWidget {
  final List<CLCustomMenuItem?> menuItems;

  const CLCustMenuRow({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: menuItems
            .map((e) => Expanded(
                  child: Align(
                    alignment: (e == null) ? Alignment.center : e.alignment,
                    child: (e == null)
                        ? Container()
                        : CLCustMenuRowButton(menuItem: e),
                  ),
                ))
            .toList());
  }
}
