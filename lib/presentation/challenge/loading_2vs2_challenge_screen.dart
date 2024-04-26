import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/battle/room_v2_model.dart';
import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/presentation/challenge/loading_meeting_challenge_screen.dart';
import 'package:chicken_combat/presentation/challenge/room_wait_2v2_screen.dart';
import 'package:chicken_combat/presentation/challenge/room_wait_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/animation/loading_animation.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'battle_map/battle_1vs1_screen.dart';

class Loading2V2ChallegenScreen extends StatefulWidget {
  const Loading2V2ChallegenScreen({super.key});

  @override
  State<Loading2V2ChallegenScreen> createState() => _Loading2V2ChallegenScreenState();
}

class _Loading2V2ChallegenScreenState extends State<Loading2V2ChallegenScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  String _loadingText = 'Matching';

  List<AskModel> _asks = [];

  void initState() {
    super.initState();
    _configAnimation();
    Future.delayed(Duration.zero, () {
      AudioManager.playRandomBackgroundMusic();
    });
    _initializeData();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    RoomV2CheckResult _room = await ensureRoomAvailable();
    await Future.delayed(Duration(seconds: 1));
    if (_room.isNew) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => RoomWait2v2Screen(_room.room)));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(
          builder: (context) => RoomWait2v2Screen(_room.room)));
    }
  }

  Future<RoomV2Model?> findEmptyRoom() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseEnum.roomV2)
          .where('user', isNotEqualTo: [])
          .get();
      for (var doc in querySnapshot.docs) {
        List<dynamic> users = doc.get('user');
        if (users.length < 4) {
          Map<String, dynamic> user = users.first as Map<String, dynamic>;
          if (user['userid'] != Globals.currentUser!.id) {
            return RoomV2Model.fromSnapshot(doc);
          }
        }
      }
    } catch (e) {
      print("Error fetching single-user rooms: $e");
    }
    return null;
  }

  Future<String> createBattleStatus() async {
    StatusBattle battle = StatusBattle(
      askPosition: -1,
      userid: '',
      correct: false, id: '',
    );
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(FirebaseEnum.battlestatus)
          .add(battle.toJson());
      battle.id = ref.id;
      return battle.id;
    } catch (e) {
      print("Error creating new room: $e");
      throw Exception("Failed to create a new room");
    }
  }

  Future<RoomV2Model> createNewRoom() async {
    Timestamp now = Timestamp.now();
    List<UserInfoRoomV2> initialUsers = [];
    if (Globals.currentUser?.id != null) {
      initialUsers.add(UserInfoRoomV2(
          userId: Globals.currentUser!.id,
          username: Globals.currentUser!.username,
          usecolor: Globals.currentUser!.useSkin != ""
              ? Globals.currentUser!.useSkin
              : Globals.currentUser!
              .useColor,
          ready: false,
          team: 1));
      // initialUsers.add(UserInfoRoomV2(
      //     userId: '${Globals.currentUser!.id}test12',
      //     username: '${Globals.currentUser!.id}test12',
      //     usecolor: 'CO03',
      //     ready: true,
      //     team: 1));
      // initialUsers.add(UserInfoRoomV2(
      //     userId: '${Globals.currentUser!.id}test21',
      //     username: '${Globals.currentUser!.id}test21',
      //     usecolor: 'CO04',
      //     ready: true,
      //     team: 2));
      // initialUsers.add(UserInfoRoomV2(
      //     userId: '${Globals.currentUser!.id}test22',
      //     username: '${Globals.currentUser!.id}test21',
      //     usecolor: 'CO02',
      //     ready: true,
      //     team: 2));
    }
    String battleId = await createBattleStatus();
    List<AskModel> asks = await _loadAsks();
    RoomV2Model newRoom = RoomV2Model(
        id: '',
        timestamp: now,
        type: 1,
        status: battleId,
        users: initialUsers,
        asks: asks
    );
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(FirebaseEnum.roomV2)
          .add(newRoom.toJson());
      newRoom.id = ref.id;
      print("New room created with ID: ${newRoom.id}");
      return newRoom;
    } catch (e) {
      print("Error creating new room: $e");
      throw Exception("Failed to create a new room");
    }
  }

  Future<RoomV2CheckResult> ensureRoomAvailable() async {
    RoomV2Model? emptyRoom = await findEmptyRoom();
    if (emptyRoom == null) {
      print("No empty room available, creating a new one.");
      return RoomV2CheckResult(room: await createNewRoom(), isNew: true);
    } else {
      bool userAlreadyInRoom = emptyRoom.users.any((user) => user.userId == Globals.currentUser?.id);
      if (!userAlreadyInRoom && Globals.currentUser?.id != null) {
        int teamAssignment = (emptyRoom.users.length == 2 || emptyRoom.users.length == 3) ? 2 : 1;
        emptyRoom.users.add(UserInfoRoomV2(
            userId: Globals.currentUser!.id,
            username: Globals.currentUser!.username,
            usecolor: Globals.currentUser!.useSkin != "" ? Globals.currentUser!.useSkin : Globals.currentUser!.useColor,
            ready: false,
            team: teamAssignment));
        await emptyRoom.updateUsers();
      }
      return RoomV2CheckResult(room: emptyRoom, isNew: false);
    }
  }

  Future<List<AskModel>> _loadAsks() async {
    List<AskModel> loadedAsks = await _getAsk();
    Random random = Random();
    if (loadedAsks.length < 9) {
      throw Exception("Not enough questions to select from.");
    }
    Set<int> usedIndexes = Set<int>();
    List<AskModel> selectedAsks = [];
    while (selectedAsks.length < 9) {
      int randomNumber = random.nextInt(loadedAsks.length);
      if (!usedIndexes.contains(randomNumber)) {
        selectedAsks.add(loadedAsks[randomNumber]);
        usedIndexes.add(randomNumber);
      }
    }
    return selectedAsks;
  }


  Future<List<AskModel>> _getAsk() async {
    List<AskModel> readings = [];
    try {
      FirebaseDatabase database = FirebaseDatabase(
        app: Firebase.app(),
        databaseURL: FirebaseEnum.URL_REALTIME_DATABASE,
      );
      final ref = database.ref(FirebaseEnum.reading);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List) {
          for (var item in data) {
            AskModel model = AskModel.fromJson(item);
            readings.add(model);
          }
        }
      } else {
        print('No data available.');
      }
    } catch (e) {
      print('Error fetching and parsing data: $e');
    }
    return readings;
  }

  void _configAnimation() {
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation1 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeInOut,
      ),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation2 = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOut,
      ),
    );

    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _animation3 = Tween<double>(begin: 1.0, end: 4.0).animate(_controller3)
      ..addListener(() {
        setState(() {
          updateLoadingText();
        });
      });
  }

  void updateLoadingText() {
    int dotsCount = _animation3.value.floor() % 3 + 1;
    _loadingText = 'Matching' + '.' * dotsCount;
  }

  Widget _buildBottom() {
    return Container(
      height: AppSizes.maxHeight,
      width: AppSizes.maxWidth,
      color: Color(0xFFFACA44),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Positioned(
          top: AppSizes.maxHeight * 0.1,
          left: 100,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value * 100, // Adjust the curve radius here
                child: child,
              );
            },
            child: _smallCloud(),
          ),
        ),
        Positioned(
          top: AppSizes.maxHeight * 0.2,
          left: 20,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value * 50, // Adjust the curve radius here
                child: child,
              );
            },
            child: _cloud(),
          ),
        ),
        Positioned(
          top: AppSizes.maxHeight * 0.3,
          right: 80,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value * 70, // Adjust the curve radius here
                child: child,
              );
            },
            child: _mediumCloud(),
          ),
        ),
        Positioned(
          top: AppSizes.maxHeight * 0.6,
          left: 60,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value * 40, // Adjust the curve radius here
                child: child,
              );
            },
            child: _mediumCloud(),
          ),
        ),
        Positioned(
          top: AppSizes.maxHeight * 0.7,
          right: 150,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value * 50, // Adjust the curve radius here
                child: child,
              );
            },
            child: _smallCloud(),
          ),
        ),
        Positioned(
          top: AppSizes.maxHeight * 0.8,
          left: 40,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value * 60, // Adjust the curve radius here
                child: child,
              );
            },
            child: _mediumCloud(),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              fit: BoxFit.contain,
              image: AssetImage(Assets.chicken_flapping_swing_gif),
              width: AppSizes.maxWidth * 0.5,
              height: AppSizes.maxHeight * 0.18,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: AnimatedBuilder(
                animation: _controller3,
                builder: (context, child) {
                  return Text(
                    _loadingText,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  );
                },
              ),
            ),
            Center(
              child: LoadingAnimation(
                offsetSpeed: Offset(1, 0),
                width: 220,
                height: 16,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ],
    );
  }

  Widget _cloud() {
    return Container(
      child: Image(
        fit: BoxFit.contain,
        image: AssetImage(Assets.img_cloud_big),
        width: AppSizes.maxWidth * 0.12,
        height: AppSizes.maxHeight * 0.04,
      ),
    );
  }

  Widget _smallCloud() {
    return Container(
      child: Image(
        fit: BoxFit.contain,
        image: AssetImage(Assets.img_cloud_small),
        width: AppSizes.maxWidth * 0.06,
        height: AppSizes.maxHeight * 0.04,
      ),
    );
  }

  Widget _mediumCloud() {
    return Container(
      child: Image(
        fit: BoxFit.contain,
        image: AssetImage(Assets.img_cloud_small),
        width: AppSizes.maxWidth * 0.1,
        height: AppSizes.maxHeight * 0.08,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      child: Scaffold(
        body: Responsive(mobile: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
              _buildContent(),
            ],
          ),
        ),desktop: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
              _buildContent(),
            ],
          ),
        ),tablet: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
              _buildContent(),
            ],
          ),
        ),),
      ),
    );
  }
}
