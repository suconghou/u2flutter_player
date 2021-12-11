import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_player_control.dart';

class ControllerWidget extends InheritedWidget {
  const ControllerWidget(
      {required this.controlKey,
      required this.child,
      required this.controller,
      required this.videoInit,
      required this.title})
      : super(child: child);

  final String title;
  final GlobalKey<VideoPlayerControlState> controlKey;
  final Widget child;
  final VideoPlayerController controller;
  final bool videoInit;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ControllerWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ControllerWidget>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

String _f(int s) {
  if (s < 10) {
    return "0$s";
  }
  return "$s";
}

String durationStr(int ms) {
  final sec = ms ~/ 1000;
  if (sec < 60) {
    return "00:${_f(sec)}";
  }
  if (sec < 3600) {
    final m = (sec / 60).floor();
    final ss = sec - m * 60;
    return "${_f(m)}:${_f(ss)}";
  }
  final h = (sec / 3600).floor();
  final mm = ((sec - 3600 * h) / 60).floor();
  final ss = sec - 3600 * h - 60 * mm;
  return "$h:${_f(mm)}:${_f(ss)}";
}
