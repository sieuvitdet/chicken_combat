import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';
class BackGroundCloudWidget extends StatefulWidget {
  const BackGroundCloudWidget({super.key});

  @override
  State<BackGroundCloudWidget> createState() => _BackGroundCloudWidgetState();
}

class _BackGroundCloudWidgetState extends State<BackGroundCloudWidget> with TickerProviderStateMixin {

late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;
    void initState() {
    super.initState();
    _configAnamation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
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
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation2 = Tween<Offset>(
      begin:Offset.zero,
      end: Offset(1,0),
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

        Positioned(
          top: AppSizes.maxHeight * 0.9,
          right: 100,
          child: AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation2.value * 100, // Adjust the curve radius here
                child: child,
              );
            },
            child: _smallCloud(),
          ),
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
    return Container(
      child: Stack(
        fit: StackFit.loose,
        children: [
          SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
          _buildContent(),
        ],
      ),
    );
  }
}


class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    required this.mobile,
   required this.tablet,
   required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          AppSizes.maxWidth = constraints.maxWidth/4;
          return desktop;
        }
        else if (constraints.maxWidth >= 650) {
          // AppSizes.maxWidth = constraints.maxWidth/2;
          // AppSizes.maxHeight = constraints.maxHeight;
          return tablet;
        }
        else {
          // AppSizes.maxWidth = constraints.maxWidth;
          // AppSizes.maxHeight = constraints.maxHeight;
          return mobile;
        }
      },
    );
  }
}