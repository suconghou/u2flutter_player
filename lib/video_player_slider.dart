import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'controller_widget.dart';

class VideoPlayerSlider extends StatefulWidget {
  final Function startPlayControlTimer;
  final Timer timer;

  VideoPlayerSlider({required this.startPlayControlTimer, required this.timer});

  @override
  _VideoPlayerSliderState createState() => _VideoPlayerSliderState();
}

class _VideoPlayerSliderState extends State<VideoPlayerSlider> {
  VideoPlayerController get controller =>
      ControllerWidget.of(context).controller;

  bool get videoInit => ControllerWidget.of(context).videoInit;
  double progressValue = 0; //进度
  String labelProgress = ""; //tip内容
  bool handle = false; //判断是否在滑动的标识

  @override
  void initState() {
    super.initState();
    progressValue = 0.0;
    labelProgress = '00:00';
  }

  @override
  void didUpdateWidget(VideoPlayerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!handle && videoInit) {
      int position = controller.value.position.inMilliseconds;
      int duration = controller.value.duration.inMilliseconds;
      if (position >= duration) {
        position = duration;
      }
      setState(() {
        progressValue = position / duration * 100;
        labelProgress = durationStr(progressValue.toInt());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      //自定义风格
      data: SliderTheme.of(context).copyWith(
        //进度条滑块左边颜色
        inactiveTrackColor: Colors.white,
        overlayShape: RoundSliderOverlayShape(
          //可继承SliderComponentShape自定义形状
          overlayRadius: 10, //滑块外圈大小
        ),
        thumbShape: RoundSliderThumbShape(
          //可继承SliderComponentShape自定义形状
          disabledThumbRadius: 7, //禁用是滑块大小
          enabledThumbRadius: 7, //滑块大小
        ),
      ),
      child: Slider(
        value: progressValue,
        label: labelProgress,
        divisions: 100,
        onChangeStart: _onChangeStart,
        onChangeEnd: _onChangeEnd,
        onChanged: _onChanged,
        min: 0,
        max: 100,
      ),
    );
  }

  void _onChangeEnd(_) {
    if (!videoInit) {
      return;
    }
    widget.startPlayControlTimer();
    // 关闭手动操作标识
    handle = false;
    // 跳转到滑动时间
    int duration = controller.value.duration.inMilliseconds;
    controller.seekTo(
      Duration(milliseconds: (progressValue / 100 * duration).toInt()),
    );
//    if (!controller.value.isPlaying) {
//      controller.play();
//    }
  }

  void _onChangeStart(_) {
    if (!videoInit) {
      return;
    }
    widget.timer.cancel();
    // 开始手动操作标识
    handle = true;
//    if (controller.value.isPlaying) {
//      controller.pause();
//    }
  }

  void _onChanged(double value) {
    if (!videoInit) {
      return;
    }
    widget.timer.cancel();
    int duration = controller.value.duration.inMilliseconds;
    setState(() {
      progressValue = value;
      labelProgress = durationStr((value / 100 * duration).toInt());
    });
  }
}
