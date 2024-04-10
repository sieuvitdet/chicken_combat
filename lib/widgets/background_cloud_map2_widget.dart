import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';


class BackgroundCloudMap2Widget extends StatefulWidget {
  final double heightContent;
  BackgroundCloudMap2Widget({super.key,required this.heightContent});

  @override
  State<BackgroundCloudMap2Widget> createState() => _BackgroundCloudMap2WidgetState();
}

class _BackgroundCloudMap2WidgetState extends State<BackgroundCloudMap2Widget>  with TickerProviderStateMixin {

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
      height: widget.heightContent,
      width:  AppSizes.maxWidthTablet > 0 ?  AppSizes.maxWidthTablet : AppSizes.maxWidth,
      child: Image.asset(Assets.img_background_blue, fit: BoxFit.cover),
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
    return Center(
      child: Container(
        width: AppSizes.maxWidth,
        height: AppSizes.maxHeight,
        child: Stack(
          fit: StackFit.loose,
          children: [
            SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(), child: _buildBottom()),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}