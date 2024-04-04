import 'package:chicken_combat/common/assets.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconTheme(
            data: IconThemeData(size: 24.0), // Set the size here
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {},
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Image.asset(Assets.ic_menu, height: 24),
            )
          ],
          title: Text("Cừa hàng",
              style: TextStyle(color: Colors.black, fontSize: 24))),
    );
  }
}
