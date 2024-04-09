import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/examination/map_reading_examination_screen.dart';
import 'package:chicken_combat/presentation/examination/map_writing_examination_screen.dart';
import 'package:chicken_combat/presentation/examination/map_listening_examination_screen.dart';
import 'package:chicken_combat/presentation/examination/map_speaking_examination_screen.dart';
import 'package:chicken_combat/presentation/map/map1_screen.dart';
import 'package:chicken_combat/presentation/map/map2_screen.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListMapExaminationScreen extends StatefulWidget {
  final String type;
  ListMapExaminationScreen({super.key, this.type = ""});

  @override
  State<ListMapExaminationScreen> createState() =>
      _ListMapExaminationScreenState();
}

class _ListMapExaminationScreenState extends State<ListMapExaminationScreen> {
  int numberMap = 5;

  List<int> _listMapInt = [];
  @override
  void initState() {
    super.initState();
    _listMapInt = List.generate(numberMap, (index) => index);
    print(_listMapInt);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.contain,
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

  Widget _map(int level, bool isLock) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: level == 0,
        blueColor: level == 1,
        redBlurColor: level == 2,
        child: Stack(
          children: [
            Center(
              child: Text("Map ${level + 1}",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                right: AppSizes.maxWidth / 3,
                child: (isLock)
                    ? ImageIcon(
                        AssetImage(Assets.ic_block),
                        color: Colors.white,
                      )
                    : Container())
          ],
        ),
        onTap: () async {
          switch (level) {
            case 0:
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Map1Screen(type: widget.type)));

            
            case 1:
              Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Map2Screen(type: widget.type)));
              break;
            default:
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFACA44),
      body: Responsive(
        mobile: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        ),
        tablet: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ),
      desktop: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ),
      ),
    );
  }
}
