import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/challenge/list_challenge_screen.dart';
import 'package:chicken_combat/presentation/examination/list_examination_screen.dart';
import 'package:chicken_combat/presentation/lesson/list_lesson_screen.dart';
import 'package:chicken_combat/presentation/map/listmap_screen/listmap_screen.dart';
import 'package:chicken_combat/presentation/shopping/shopping_screen.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _function() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _action(0,"Bài học", () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListLessonScreen()));
          }),
          _action(1,"Kiểm tra",  () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ListExaminationScreen()));
          }),
          _action(2,"Thử thách", () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListChallengeScreen()));
          })
        ],
      ),
    );
  }

  Widget _info() {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.sizeAppBar / 2),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(Assets.img_avatar),
                    width: 50,
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Tên User"), Text("Level 3")],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              _itemRow("200", Assets.ic_coin),
              SizedBox(width: 4),
              _itemRow("2000", Assets.ic_diamond),
              SizedBox(width: 4),
              _itemRow("Cửa hàng", Assets.ic_shop, ontap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShoppingScreen()));
              })
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 8),
      width: AppSizes.maxWidth,
      child: Image(
          fit: BoxFit.cover, image: AssetImage("assets/images/farm_gif.gif")),
    ));
  }

  Widget _action(int iD,String name, Function onTap) {
    return Container(
      padding: EdgeInsets.symmetric( vertical: 8),
      child: CustomButtomImageColorWidget(
        yellowColor: iD == 0,
        blueColor: iD == 1,
        redBlurColor: iD == 2,
        child: Center(child: Text(name, style: TextStyle(fontSize:24, color: Colors.white))),
        onTap: onTap as void Function()?,
      ),
    );
  }

  Widget _itemRow(String text, String icon,{Function? ontap}) {
    return GestureDetector(
      onTap: ontap as void Function()?,
      child: Container(
        height: 48,  
        width: 70,
        decoration: BoxDecoration(
            color: Color(0xFF97381A), borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(icon),
                width: 20,
                height: 20,
              ),
              Text(
                text,
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFA9C20),
      body: Column(
        children: [_info(), _body(), _function()],
      ),
    );
  }
}
