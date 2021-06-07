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
