import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen({super.key});

  @override
  State<ListMapScreen> createState() => _ListMapScreenState();
}

class _ListMapScreenState extends State<ListMapScreen> {
  int numberMap = 6;

  List<int> _listMapInt = [];
  @override
  void initState() {
    super.initState();
    _listMapInt = List.generate(numberMap, (index) => index);
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.fitHeight,
          image: AssetImage(Assets.chicken_flapping_swing_gif),
          width: AppSizes.maxWidth * 0.3,
          height: AppSizes.maxHeight * 0.18,
        ),
        ..._listMap()
      ],
    );
  }

  List<Widget> _listMap() {
    List<Widget> itemList = [];
    for (int i = 0; i < numberMap; i++) {
      itemList.add(_map(i, _listMapInt[i] == 3 || _listMapInt[i] == 4));
    }
    return itemList;
  }

  Widget _map(int level , bool isLock) {
    // return GestureDetector(
    //   onTap: () async {
    //     switch (level) {
    //       case 0:
    //         Navigator.of(context)
    //             .push(MaterialPageRoute(builder: (context) => Map1Screen()));
    //       case 1:
    //         Navigator.of(context)
    //             .push(MaterialPageRoute(builder: (context) => Map2Screen()));
    //       case 2:
    //         Navigator.of(context)
    //             .push(MaterialPageRoute(builder: (context) => Map3Screen()));
    //         break;
    //       default:
    //     }
    //   },
    //   child: Container(
    //     width: AppSizes.maxWidth,
    //     margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //     height: 48,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8.0), 
    //         color: isLock ? Color(0xFF8C8482) : color),
    //     child: Stack(
    //       children: [
    //         Center(
    //           child: Text("Map ${level + 1}",
    //               style: TextStyle(fontSize: 16, color: Colors.white)),
    //         ),
    //         Positioned(
    //             top: 0,
    //             bottom: 0,
    //             right: AppSizes.maxWidth / 3.5,
    //             child: (isLock)
    //                 ? ImageIcon(
    //                     AssetImage(Assets.ic_block),
    //                     color: Colors.grey,
    //                   )
    //                 : Container())
    //       ],
    //     ),
    //   ),
    // );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: CustomButtomImageColorWidget(
        yellowColor: level == 0,
        blueColor: level == 1,
        redBlurColor: level == 2,
        child: Stack(
            children: [
              Center(
                child: Text("Map ${level + 1}",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  right: AppSizes.maxWidth / 3.5,
                  child: (isLock)
                      ? ImageIcon(
                          AssetImage(Assets.ic_block),
                          color: Colors.grey,
                        )
                      : Container())
            ],
          ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ),
    );
  }
}
