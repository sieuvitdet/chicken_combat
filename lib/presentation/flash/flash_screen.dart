import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/login/login_screen.dart';
import 'package:chicken_combat/widgets/animation/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> with TickerProviderStateMixin {
  @override

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
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);
    _animation2 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.5, 0.5),
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOut,
      ),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.loose,
        children: [
          SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: _buildBottom()),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Image.asset(Assets.img_imgBackGround, fit: BoxFit.contain);
  }

  Widget _buildContent() {
    return Stack(
      children: [

        Positioned(
          top: 250,
          left: 50,
          child: AnimatedBuilder(
          animation: _animation1,
          builder: (context, child) {
            return Transform.translate(
              offset: _animation1.value * 200, // Adjust the curve radius here
              child: child,
            );
          },
          child: _smallCloud(),
            ),
        ),

       Positioned(
        top: 200,
         child: AnimatedBuilder(
          animation: _animation2,
          builder: (context, child) {
            return Transform.translate(
              offset: _animation2.value * 200, // Adjust the curve radius here
              child: child,
            );
          },
          child: _cloud(),
               ),
       ),




        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/chicken_dancing.gif"),
                width: AppSizes.maxWidth * 0.3,
                height: AppSizes.maxHeight * 0.18,
              ),
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
