import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/presentation/event/event_challenge_screen.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

import '../../common/themes.dart';
import '../../widgets/background_cloud_general_widget.dart';

class EventInformationScreen extends StatefulWidget {
  const EventInformationScreen({super.key});

  @override
  State<EventInformationScreen> createState() => _EventInformationScreenState();
}

class _EventInformationScreenState extends State<EventInformationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.yellowAccent.withOpacity(0.4),
                spreadRadius: 8, // Độ lan của viền
                blurRadius: 24, // Độ mờ
                offset: Offset(0, 0), // Tọa độ của bóng (0, 0 để nằm đều xung quanh)
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Assets.img_chicken_noel_1,
              width: 160,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.yellow,
                  Colors.orange,
                  Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: StrokeTextWidget(
                text:
                    "Hãy tham gia thử thách để có cơ hội nhận được bạn gà noel phiên bản 2024 bạn nhé!",
                size: 24,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 150,
        ),
        ScalableButton(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventChallengeScreen()));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_button_orange,
                width: AppSizes.maxWidth * 0.9,
                fit: BoxFit.contain,
              ),
              StrokeTextWidget(
                text: "Tham gia ngay",
                size: 13,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        BackGroundCloudWidget(),
        Positioned(
          top: MediaQuery.of(context).padding.top / 2,
          left: 16.0,
          child: SafeArea(
            child: Positioned(
              top: AppSizes.maxHeight * 0.05,
              left: AppSizes.maxWidth * 0.03,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFD700),
                        Color(0xFFFFEA9F)
                      ], // Gradient từ vàng sang đỏ
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  // Kích thước nút
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
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
        ),
      ),
    );
  }
}
