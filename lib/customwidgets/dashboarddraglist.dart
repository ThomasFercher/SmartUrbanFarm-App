import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

import 'package:sgs/providers/dashboardProvider.dart';

import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

class DashboardDragList extends StatefulWidget {
  final List<Widget> items;

  const DashboardDragList({Key key, this.items}) : super(key: key);

  @override
  _DashboardDragListState createState() => _DashboardDragListState();
}

class _DashboardDragListState extends State<DashboardDragList> {
  List<Widget> items;

  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ImplicitlyAnimatedReorderableList<Widget>(
      items: items,
      areItemsTheSame: (oldItem, newItem) => oldItem.key == newItem.key,
      onReorderFinished: (item, from, to, newItems) {
        // Remember to update the underlying data when the list has been
        // reordered.
        Provider.of<DashboardProvider>(context, listen: false).pressed();
        setState(() {
          items
            ..clear()
            ..addAll(newItems);
        });
      },
      itemBuilder: (context, itemAnimation, item, index) {
        // Each item must be wrapped in a Reorderable widget.
        return Reorderable(
          // Each item must have an unique key.
          key: ValueKey(item),
          // The animation of the Reorderable builder can be used to
          // change to appearance of the item between dragged and normal
          // state. For example to add elevation when the item is being dragged.
          // This is not to be confused with the animation of the itemBuilder.
          // Implicit animations (like AnimatedContainer) are sadly not yet supported.
          builder: (context, dragAnimation, inDrag) {
            final t = dragAnimation.value;
            final elevation = 30.0;
            final color =
                Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: itemAnimation,
              child: Material(
                color: color,
                elevation: elevation,
                shadowColor: Colors.black,
                type: MaterialType.transparency,
                child: Consumer<DashboardProvider>(
                  builder: (context, dashb, child) {
                    return GestureDetector(
                      onLongPressStart: (details) {
                        var a = details.globalPosition;
                        print(a);
                      },
                      onLongPressEnd: (details) {
                        var a = details.globalPosition;
                        print(a);
                        Provider.of<DashboardProvider>(context, listen: false)
                            .pressed();
                      },
                      child: Stack(
                        children: [
                          Container(
                            child: item,
                          ),
                          Handle(
                            vibrate: true,
                            delay: Duration(milliseconds: 500),
                            child: Container(
                              height: 35,
                              width: 35,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width - 64,
                                top: 35,
                              ),
                              child: OutlineButton(
                                borderSide: BorderSide(style: BorderStyle.none),
                                color: Colors.white,
                                padding: EdgeInsets.all(0),
                                //  onLongPress: () => {},
                                onPressed: () => {
                                  //Implement Settings
                                },
                                child: const Icon(Icons.drag_handle),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
