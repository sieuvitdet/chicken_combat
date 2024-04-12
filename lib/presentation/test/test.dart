import 'package:chicken_combat/common/assets.dart';
import 'package:flutter/material.dart';

class testscreen extends StatefulWidget {
  const testscreen({super.key});

  @override
  State<testscreen> createState() => _testscreenState();
}

class _testscreenState extends State<testscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6FBFF),
      appBar: AppBar(
        title: Text("Thông tin đổi quà"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Container(
            height: 84,
            color: Colors.white,
            child: Row(
              children: [
                Image.asset(
                  Assets.img_breath_machine,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 16.0,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Thẻ điện thoại 50050505050505050500505050500550",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                        Text("Giá trị: 50.000đ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ))
                  ],
                ))
              ],
            ),
          ),
          SizedBox(height: 16),
          _nameGift("Thẻ điện thoại aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
          SizedBox(height: 1),
          _price(5000000),
          SizedBox(height: 1),
          _xu(100),
          SizedBox(height: 24),

          Container(
            height: 48,
            margin: EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color(0xFF005EB8)
            ),
            child: Center(
              child: Text(
                "Xác nhận",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          )
        
          
        ],
      ),
    );
  }

  Widget _nameGift(String? nameGift) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 48,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              "Tên quà",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF939393)),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(nameGift ?? "",
            maxLines: 1,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
          )
        ],
      ),
    );
  }

  Widget _price(int? price) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 48,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Giá trị",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF939393)),
          ),
          Text("${(price ?? 0).toDouble().round()}",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ))
        ],
      ),
    );
  }

  Widget _xu(int? value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 48,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Giá trị",
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF939393)),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("$value",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              Image.asset(
                Assets.ic_coin,
                width: 12,
              )
            ],
          )
        ],
      ),
    );
  }
}
