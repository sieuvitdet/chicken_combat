import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/flash/flash_screen.dart';
import 'package:chicken_combat/widgets/custom_expanedable_draggable_fab_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Itim",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      builder: (context, child) {
        AppSizes.init(context);
        return MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.0,
            maxScaleFactor: 1.2,
            child: GestureDetector(
              child: child,
            ));
      },
      home: FlashScreen(),
    );
  }
}


class DragItem extends StatefulWidget {
  const DragItem({super.key});

  @override
  State<DragItem> createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableDraggableFab(
          initialDraggableOffset:
              Offset(12, MediaQuery.of(context).size.height * 11 / 14),
          initialOpen: false,
          curveAnimation: Curves.easeOutSine,
          childrenBoxDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10.0)),
          childrenCount: 1,
          distance: 10,
          childrenType: ChildrenType.columnChildren,
          childrenAlignment: Alignment.centerRight,
          childrenInnerMargin: EdgeInsets.all(15.0),
          closeWidget: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.3),
                )
              ], shape: BoxShape.circle, color: Color(0xFF5F5F5F)),
              width: 60,
              height: 60,
              child: Icon(
                Icons.clear,
                size: 35,
                color: Colors.white,
              )), children: [DialogConfirmWidget()],
          
        )
    );
  }
}

