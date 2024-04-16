import 'dart:math' as math;
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_draggale_widget.dart';
import 'package:flutter/material.dart';

@immutable
class DraggableStackWidget extends StatefulWidget {
  const DraggableStackWidget(
      {this.initialDraggableOffset, this.onTapAction, this.onTapClose});

  final VoidCallback? onTapAction;
  final VoidCallback? onTapClose;
  final Offset? initialDraggableOffset;

  @override
  State<DraggableStackWidget> createState() => _DraggableStackWidgetState();
}

class _DraggableStackWidgetState extends State<DraggableStackWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox.expand(
      key: _key,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          SizedBox.shrink(),
          DraggableWidget(
            parentKey: _key,
            initialOffset:
                widget.initialDraggableOffset ?? Offset(20, size.height - 80),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _buildTapToOpenFab(),
                Positioned(
                  top: -5,
                  right: -5,
                  child: ScalableButton(
                    onTap: widget.onTapClose,
                    child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        child:  Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 12,
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return GestureDetector(
      onTap: widget.onTapAction,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),color: Colors.pink.withOpacity(0.5)),
          width: 100,
          height: 100,
          child: Image.asset(Assets.img_chicken)),
    );
  }
}

enum ChildrenTransition { scaleTransation, fadeTransation }
