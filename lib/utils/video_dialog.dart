import 'dart:async';

import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDialog extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String? urlVideo;
  final String keyPrefs;

  VideoDialog({super.key, this.onTap, this.urlVideo, required this.keyPrefs});

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _controller;
  bool _doNotShowAgain = false;
  bool _isCloseButtonEnabled = false;
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doNotShowAgain = Globals.prefs!.getBool(widget.keyPrefs);
    _controller = VideoPlayerController.asset(
        widget.urlVideo ?? 'assets/videos/video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _startCountdown();
  }

  dispose() {
    super.dispose();
    _controller.dispose();
    _timer?.cancel();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isCloseButtonEnabled = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hiển thị video
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.6,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    hoverColor: Colors.white,
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: _doNotShowAgain,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      },
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        _doNotShowAgain = value ?? false;
                      });
                    },
                  ),
                  Text(
                    "Không hiển thị lần sau",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              _countdown > 0
                  ? CustomButtomImageColorWidget(
                onTap: null,
                child: Text(
                  'Đóng ($_countdown)',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : CustomButtomImageColorWidget(
                redColor: true,
                onTap: _isCloseButtonEnabled
                    ? () {
                  widget.onTap!();
                  Globals.prefs?.setBool(widget.keyPrefs, _doNotShowAgain);
                }
                    : null,
                child: Text(
                  'Đóng',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
