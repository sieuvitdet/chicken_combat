import 'package:audioplayers/audioplayers.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/finance_model.dart';
import 'package:chicken_combat/model/maps/map_model.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/challenge/list_challenge_screen.dart';
import 'package:chicken_combat/presentation/examination/list_examination_screen.dart';
import 'package:chicken_combat/presentation/lesson/list_lesson_screen.dart';
import 'package:chicken_combat/presentation/shopping/shopping_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_account_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  UserModel? _userModel;
  FinanceModel? _financeModel;
  bool _isChickenSing = false;
  bool _isPlay = false;
  bool _isEnablePlay = false;
  bool _isEnableResume = false;

  @override
  void initState() {
    super.initState();
    _userModel = Globals.currentUser;
    _initializeData();
    _configAnamation();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      AudioManager.playRandomBackgroundMusic();
    });
  }

  @override
  void dispose() {
    AudioManager.stopBackgroundMusic();
    //  _pauseChickenSing();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioManager.pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      AudioManager.resumeBackgroundMusic();
    }
  }

  Future<void> _initializeData() async {
    await _getFinance(_userModel!.financeId);
    await _getStore();
    await _getMaps();
  }

  void _playChickenSing() {
    AudioManager.stopBackgroundMusic();
    AudioManager.playRandomChickenSing();
  }

  Future<void> _pauseChickenSing() async {
    await AudioManager.resumeBackgroundMusic();
    await AudioManager.pauseVoiceMusic();
  }

  Future<void> _resummeChickenSing() async {
    await AudioManager.stopBackgroundMusic();
    await AudioManager.resumeVoiceMusic();
  }

  Future<void> _getFinance(String _id) async {
    CollectionReference finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);
    finance.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        setState(() {
          _financeModel = FinanceModel.fromSnapshot(documentSnapshot);
          Globals.financeUser = _financeModel;
        });
      }
    });
  }

  Future<void> _getStore() async {
    Globals.listStore.clear();
    FirebaseFirestore.instance
        .collection(FirebaseEnum.store)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        StoreModel storeModel = StoreModel.fromSnapshot(doc);
        Globals.listStore.add(storeModel);
      });
    });
  }

  Future<void> _getMaps() async {
    List<MapModel> maps = [];
    Globals.mapsModel.clear();
    FirebaseFirestore.instance
        .collection(FirebaseEnum.maps)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        maps.add(MapModel.fromSnapshot(doc));
      });
      Globals.mapsModel = maps;
    });
  }

  void _configAnamation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: -AppSizes.maxHeight * 0.22, end: AppSizes.maxHeight*0.02)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isEnablePlay = true;
        });
      }
    });
  }

  Widget _function() {
    return Container(
      width: AppSizes.maxWidth,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _action(0, "Bài học", () async {
           await _pauseChickenSing();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListLessonScreen(
                      courseMapModel: _userModel!.courseMapModel,
                    )));
          }),
          _action(1, "Kiểm tra", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListExaminationScreen(
                    mapModel: _userModel!.checkingMapModel)));
          }),
          _action(2, "Thử thách", () {
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
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScalableButton(
                    onTap: () {
                      AudioManager.playSoundEffect(AudioFile.sound_tap);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) setState) {
                                return DialogAccountWidget();
                              },
                            );
                          });
                    },
                    child: Image(
                      image: AssetImage(Assets.img_avatar),
                      width: AppSizes.maxHeight * 0.055,
                      height: AppSizes.maxHeight * 0.055,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userModel!.username,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text('Level ${_userModel!.level}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              _itemRow("${_financeModel?.gold ?? 0}", Assets.ic_coin,
                  ontap: () {}),
              SizedBox(width: 4),
              _itemRow("${_financeModel?.diamond ?? 0}", Assets.ic_diamond,
                  ontap: () {}),
              SizedBox(width: 4),
              _itemRow(AppLocalizations.text(LangKey.shop), Assets.ic_shop, ontap: () {
                AudioManager.playSoundEffect(AudioFile.sound_tap);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return ShoppingScreen(
                            financeModel: _financeModel!,
                          );
                        },
                      );
                    });
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
      width: Responsive.isMobile(context)
          ? AppSizes.maxWidth
          : AppSizes.maxWidthTablet,
      child: Stack(
        children: [
          Image(fit: BoxFit.cover, image: AssetImage(Assets.gif_snow_home)),
          Positioned(
              bottom: AppSizes.maxHeight*0.14,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _controller.forward();
                },
                child: Image(
                  fit: BoxFit.contain,
                  image: AssetImage(Assets.gif_chicken_black_dance),
                  width: AppSizes.maxWidth * 0.15,
                  height: AppSizes.maxHeight * 0.15,
                ),
              )),
          Positioned(
              bottom: _animation.value,
              left: 15,
              right: 0,
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage(Assets.img_micro),
                width: AppSizes.maxWidth * 0.01,
                height: AppSizes.maxHeight * 0.2,
              )),
          if (_isEnablePlay)
            Positioned(
              top: AppSizes.maxHeight*0.28,
              right: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isPlay) { // đang phát nhạc gà
                      _pauseChickenSing();
                    } else { // đang tắt nhạc gà 
                      if (_isEnableResume) {
                        _resummeChickenSing();
                      } else {
                        _isEnableResume = true;
                        _playChickenSing();
                      }
                    }
                    _isPlay = !_isPlay;
                  });
                },
                child: ShakeWidget(
                    duration: const Duration(seconds: 10),
                    shakeConstant: ShakeDefaultConstant1(),
                    autoPlay: true,
                  child: Image.asset(
                    _isPlay ? Assets.img_playing : Assets.ic_playgame_popup,
                    height: 48,
                  ),
                ),
              ),
            ),


            // Positioned(
            //   top: 200,
            //   right: 80,child: ThoughtBubble(text: "Chọt em đi"))
        ],
      ),
    ));
  }

  Widget _action(int iD, String name, Function onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomButtomImageColorWidget(
        yellowColor: iD == 0,
        blueColor: iD == 1,
        redBlurColor: iD == 2,
        child: Center(
            child: Text(name,
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () {
          onTap();
          AudioManager.playSoundEffect(AudioFile.sound_tap);
        },
      ),
    );
  }

  Widget _itemRow(String text, String icon, {Function? ontap}) {
    return GestureDetector(
      onTap: ontap as void Function()?,
      child: Container(
        height: AppSizes.maxHeight * 0.06,
        width: AppSizes.maxWidth * 0.18,
        decoration: BoxDecoration(
            color: Color(0xFF97381A),
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(icon),
                width: AppSizes.maxHeight * 0.0223,
                height: AppSizes.maxHeight * 0.0223,
              ),
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.maxWidth < 350 ? 10.0 : 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xffFA9C20),
        body: Responsive(
          desktop: Center(
            child: Container(
              // width: AppSizes.maxWidth,
              height: AppSizes.maxHeight,
              child: Column(
                children: [_info(), _body(), _function()],
              ),
            ),
          ),
          mobile: Center(
            child: Container(
              // width: AppSizes.maxWidth,
              height: AppSizes.maxHeight,
              child: Column(
                children: [_info(), _body(), _function()],
              ),
            ),
          ),
          tablet: Center(
            child: Container(
              // width: AppSizes.maxWidth,
              height: AppSizes.maxHeight,
              child: Column(
                children: [_info(), _body(), _function()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class ThoughtBubble extends StatefulWidget {
  final String text;
  ThoughtBubble({required this.text});

  @override
  _ThoughtBubbleState createState() => _ThoughtBubbleState();
}

class _ThoughtBubbleState extends State<ThoughtBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: CustomPaint(
        painter: BubblePainter(),
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 20, left: 20),
          child: Text(widget.text, style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}


class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.amber.shade100;
    var path = Path();

    // Vẽ đám mây
    path.addOval(Rect.fromCircle(center: Offset(size.width * 0.3, size.height * 0.3), radius: 30));
    path.addOval(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.25), radius: 40));
    path.addOval(Rect.fromCircle(center: Offset(size.width * 0.7, size.height * 0.3), radius: 30));

    // Vẽ mũi tên chỉ xuống
    path.moveTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.7);
    path.lineTo(size.width * 0.55, size.height * 0.7);
     path.lineTo(size.width * 0.4, size.height * 0.9);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}