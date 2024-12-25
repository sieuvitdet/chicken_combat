import 'dart:async';
import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/reward_model.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:chicken_combat/widgets/dialog_event_info_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../model/enum/firebase_data.dart';
import '../../model/user_model.dart';
import '../../utils/shared_pref_key.dart';
import '../../utils/utils.dart';
import '../../widgets/background_cloud_general_widget.dart';

class EventInformationScreen extends StatefulWidget {
  const EventInformationScreen({super.key});

  @override
  State<EventInformationScreen> createState() => _EventInformationScreenState();
}

class _EventInformationScreenState extends State<EventInformationScreen> {

  final List<String> rewards = [
    '10 Xu',
    '5 Kim cương',
    '100 Kim cương',
    '5 Xu',
    '10 Kim cương',
    'May mắn',
    '20 Xu',
    'May mắn',
  ];

  final List<double> probabilities = [
    0.1, // 10 Xu - 10%
    0.02, // 5 Kim cương - 2%
    0.0001, // Skin mới - 1%
    0.3, // 5 Xu - 30%
    0.0299, // 10 Kim cương - 2%
    0.5, // Chúc bạn may mắn - 50%
    0.05,
    0.5, // 20 Xu - 5%
  ];

  final Random random = Random();
  final StreamController<int> controller = StreamController<int>();
  bool isSpinning = false;
  late List<RewardModel> rewardList = [];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String countEvent = '0';
  @override
  void initState() {
    super.initState();
    rewardList = List.generate(
      rewards.length,
          (index) => RewardModel(name: rewards[index], probability: probabilities[index]),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserInfo();
    });
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<void> updateCountEvent() async {
    CollectionReference users = fireStore.collection(FirebaseEnum.userdata);
    users
        .doc(Globals.prefs!.getString(SharedPrefsKey.id_user))
        .update({'countEvent': int.parse(countEvent) - 1});
  }

  Future<void> updateResult(int index) async {
    CollectionReference finance = fireStore.collection(FirebaseEnum.finance);
    CollectionReference users = fireStore.collection(FirebaseEnum.userdata);

    switch(index) {
      case 0:
        finance.doc(Globals.currentUser?.financeId).update({'gold': 10});
        break;
      case 1:
        finance.doc(Globals.currentUser?.financeId).update({'diamond': 5});
        break;
      case 2:
        finance.doc(Globals.currentUser?.financeId).update({'diamond': 100});
        break;
      case 3:
        finance.doc(Globals.currentUser?.financeId).update({'gold': 5});
        break;
      case 4:
        finance.doc(Globals.currentUser?.financeId).update({'diamond': 5});
        break;
      case 5:
        break;
      case 6:
        finance.doc(Globals.currentUser?.financeId).update({'gold': 20});
        break;
      case 7:
        break;
    }
    users.doc(Globals.prefs!.getString(SharedPrefsKey.id_user)).update({'countEvent': int.parse(countEvent) - 1});
  }

  Future<void> getUserInfo() async {
    CollectionReference users = fireStore.collection(FirebaseEnum.userdata);
    users.doc(Globals.prefs!.getString(SharedPrefsKey.id_user)).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromSnapshot(documentSnapshot);
        Globals.currentUser = user;
        countEvent = user.countEvent.toString();
        if(user.countEvent == 0){
         isSpinning = true;
        }
        setState(() {});
      } else {
        print('Document không tồn tại.');
      }
    });
  }

  int _getWeightedRandomIndex() {
    final double randomValue = random.nextDouble();
    double cumulativeProbability = 0.0;

    for (int i = 0; i < rewardList.length; i++) {
      cumulativeProbability += rewardList[i].probability;
      if (randomValue <= cumulativeProbability) {
        return i;
      }
    }

    return rewardList.length - 1;
  }

  void _spinWheel() {
    if (!isSpinning) {
      setState(() {
        isSpinning = true;
      });
      int selectedIndex = _getWeightedRandomIndex();
      controller.add(selectedIndex);
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          isSpinning = false;
        });
        _showResultDialog(rewardList[selectedIndex].name, selectedIndex);
      });
    }
  }



  void _showResultDialog(String reward, int selectedIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Color(0xFFFFF3E0),
        title: Row(
          children: [
            Icon(Icons.stars, color: Color(0xFFFFD700)), // Icon vàng sáng
            SizedBox(width: 8),
            Text(
              'Kết quả',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4226), // Màu nâu
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.ic_rank_gold, // Thêm hình minh họa
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),
            Text(
              'Bạn đã nhận được: $reward!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6B4226), // Màu nâu
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await updateCountEvent();
                await getUserInfo();
                await updateResult(selectedIndex);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700), // Màu vàng tươi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B4226), // Màu nâu
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gacha() {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      elevation: 6,
      child: Stack(
        alignment: Alignment.center, // Căn giữa các thành phần
        children: [
          Container(
            width: 350, // Kích thước ảnh viền
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/img_background_lucky_wheel.png"), // Đường dẫn ảnh viền
                fit: BoxFit.cover, // Bao phủ toàn bộ khung
              ),
            ),
          ),
          Container(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [

                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.orange, Colors.yellow],
                      center: Alignment(0.5, 0.5),
                      radius: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                FortuneWheel(
                  styleStrategy:UniformStyleStrategy(
                      borderWidth: 1 ,
                      color: AppColors.primaryColor.withOpacity(0.5),
                      borderColor: Colors.white,
                  ),
                  selected: controller.stream,
                  hapticImpact: HapticImpact.light,
                  animateFirst: false,
                  physics: CircularPanPhysics(
                    duration: Duration(seconds: 4),
                    curve: Curves.bounceInOut,
                  ),
                  items: [
                    for (int i = 0; i < rewardList.length; i++)
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: i % 2 == 0 ?
                          Color(0xF6FFBFBF) :
                          Color(0xF6C2C4FF), // Màu nền chẵn/lẻ
                          borderColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StrokeTextWidget(
                              text: rewardList[i].name,
                              size: 14,
                              colorStroke: i % 2 == 0 ?
                              Color(0xF6818181) :
                              Color(0xF6818181),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hình nền
        Image.asset(
          Assets.img_background_event_tet_not_content,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),


        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: _gacha(),
          ), // Vòng quay
        ),

        // Nút Home (trở về)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16.0,
          child: _buildButton(
            onTap: () => Navigator.pop(context),
            icon: Icons.home_filled,
            gradientColors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
        ),

        // Nút "Thể lệ"
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 52,
          left: 24.0,
          child: _buildButton(
            onTap: () {
              GlobalSetting.shared.showPopupWithContext(
                  context,
                  DialogEventInfoWidget(
                    title: 'Hãy thực hiện các nhiệm vụ sau để nhận lượt quay thưởng thú vị:\n•	Hoàn thành mỗi cấp độ trong phần Học tập: Nghe, Nói và Đọc.\n•	Vượt qua mỗi cấp độ trong phần Kiểm tra: Nghe, Nói và Đọc.\n\nThử thách bản thân và tích lũy thật nhiều lượt quay để khám phá những phần thưởng hấp dẫn đang chờ đợi bạn!',
                    agree: () async {
                      Navigator.of(context).pop();
                    },
                  ));
            },
            text: 'Thể lệ',
            gradientColors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.width / 2,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StrokeTextWidget(
                text: 'Số lượt quay còn lại: $countEvent',
                size: 18,
                colorStroke: Colors.black,
              ),
            ],
          ),
        ),

        // Nút "Bắt đầu"
        Positioned(
          bottom: MediaQuery.of(context).size.width / 3,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                onTap: isSpinning ? null : _spinWheel,
                text: 'Bắt đầu',
                gradientColors: [Color(0xFFFF8C00), Color(0xFFFFEFD5)],
              ),
            ],
          ),
        ),

        // Nút "Lịch sử"
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 52,
          right: 24,
          child: _buildButton(
            onTap: () {
              // Thêm logic tại đây
            },
            text: 'Lịch sử',
            gradientColors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback? onTap,
    IconData? icon,
    String? text,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: icon != null
            ? Icon(icon, color: Colors.white, size: 20)
            : StrokeTextWidget(
          text: text ?? '',
          size: 18,
          colorStroke: Colors.black,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Container(

          child: Responsive(
            mobile: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                //_buildContent(),
              ],
            ),
            tablet: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                //_buildContent(),
              ],
            ),
            desktop: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                //_buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
