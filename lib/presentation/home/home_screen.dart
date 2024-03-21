import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/map/map1_screen.dart';
import 'package:chicken_combat/presentation/map/map2_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFA9C20),
      body: Column(
        children: [
          Container(
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
                    _itemRow("200"),
                    SizedBox(width: 4),
                    _itemRow("2000"),
                    SizedBox(width: 4),
                    _itemRow("Cửa hàng")
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 16),
            width: AppSizes.maxWidth,
            child: Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/farm_gif.gif")),
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    print("goo");
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xFFE84C3D)),
                    child: Center(
                      child: Text(
                        "Bài học",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("goo");
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.amber),
                    child: Center(
                      child: Text(
                        "Kiểm tra",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Map2Screen()));
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.blue),
                    child: Center(
                      child: Text(
                        "Thử thách",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemRow(String text) {
    return Container(
      height: 48,
      width: 70,
      decoration: BoxDecoration(
          color: Color(0xFF97381A), borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(Assets.img_store), height: 20, width: 20),
            Text(
              text,
              maxLines: 1,
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}
