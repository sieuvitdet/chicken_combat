import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/presentation/login/login_screen.dart';
import 'package:chicken_combat/widgets/animation/loading_animation.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen>
    with TickerProviderStateMixin {


  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _configAnamation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  void _configAnamation() {
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
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
            animation: _animation2,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation2.value * 50, // Adjust the curve radius here
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
            animation: _animation2,
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
              fit: BoxFit.fitHeight,
              image: AssetImage(Assets.chicken_flapping_swing_gif),
              width: AppSizes.maxWidth * 0.3,
              height: AppSizes.maxHeight * 0.18,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: RichText(
                text: TextSpan(
                  text: "Học giả gà con",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
            CountingAnimation()
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
    return Scaffold(
      body: Responsive(desktop: Stack(
          fit: StackFit.loose,
          children: [
            SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
            _buildContent(),
          ],
        ),mobile: Stack(
          fit: StackFit.loose,
          children: [
            SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
            _buildContent(),
          ],
        ),
        tablet: Stack(
          fit: StackFit.loose,
          children: [
            SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
            _buildContent(),
          ],
        ),),
    );
  }
}

class CountingAnimation extends StatefulWidget {
  @override
  _CountingAnimationState createState() => _CountingAnimationState();
}

class _CountingAnimationState extends State<CountingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return RichText(
          text: TextSpan(
            text: '${(_controller.value * 100).toInt()}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
