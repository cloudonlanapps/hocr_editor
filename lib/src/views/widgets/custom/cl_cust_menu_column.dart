import 'package:flutter/material.dart';

import 'cl_cust_menu_item.dart';

class CLCustMenuColumnButton extends StatelessWidget {
  const CLCustMenuColumnButton({Key? key, required this.choice})
      : super(key: key);
  final CLCustomMenuItem? choice;

  @override
  Widget build(BuildContext context) {
    TextStyle menuIconStyle = const TextStyle();
    if (choice == null) return Container();
    return SizedBox(
      width: 80,
      height: 80,
      child: InkWell(
        enableFeedback: true,
        onTap: choice!.onTap,
        onLongPress: choice!.onLongPress,
        child: Card(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (choice!.icon != null)
                    Expanded(
                      child: Icon(
                        choice!.icon,
                        color: choice!.color,
                        size: menuIconStyle.fontSize! * 2,
                      ),
                    ),
                  if (choice!.label != null)
                    Text(choice!.label!,
                        style: menuIconStyle.copyWith(color: choice!.color)),
                ]),
          ),
        )),
      ),
    );
  }
}

class CLCustMenuGrid extends StatelessWidget {
  final List<CLCustomMenuItem?> menuItems;
  const CLCustMenuGrid({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        children: List.generate(menuItems.length, (index) {
          return Center(
            child: CLCustMenuColumnButton(choice: menuItems[index]),
          );
        }));
  }
}
