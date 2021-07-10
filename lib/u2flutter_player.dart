import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:brightness_volume/brightness_volume.dart';
import 'package:video_player/video_player.dart';
import 'controller_widget.dart';
import 'video_player_control.dart';
import 'video_player_pan.dart';

class VideoPlayerUI extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final VideoPlayerController controller;

  VideoPlayerUI({
    required this.controller, // 当前需要播放的地址
    this.width: double.infinity, // 播放器尺寸（大于等于视频播放区域）
    this.height: double.infinity,
    this.title = '', // 视频需要显示的标题
  });

  @override
  _VideoPlayerUIState createState() {
    return _VideoPlayerUIState(controller);
  }
}

class _VideoPlayerUIState extends State<VideoPlayerUI> {
  final GlobalKey<VideoPlayerControlState> _key =
      GlobalKey<VideoPlayerControlState>();

  ///指示video资源是否加载完成，加载完成后会获得总时长和视频长宽比等信息
  bool _videoInit = false;
  bool _videoError = false;
  bool _destroyed = false;
  int render = DateTime.now().millisecondsSinceEpoch;
  final VideoPlayerController controller;

  /// 记录是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  _VideoPlayerUIState(this.controller);

  @override
  void initState() {
    super.initState();
    load(); // 初始进行一次url加载
    BVUtils.keepOn(true); // 设置屏幕常亮
  }

  @override
  void dispose() {
    _destroyed = true;
    controller.removeListener(_videoListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final full = _isFullScreen;
    return SafeArea(
      top: !full,
      bottom: !full,
      left: !full,
      right: !full,
      child: Container(
        width: full ? _window.width : widget.width,
        height: full ? _window.height : widget.height,
        child: _isHadUrl(),
      ),
    );
  }

// 判断是否有url
  Widget _isHadUrl() {
    return ControllerWidget(
      controlKey: _key,
      controller: controller,
      videoInit: _videoInit,
      title: widget.title,
      child: VideoPlayerPan(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _isVideoInit(),
        ),
      ),
    );
  }

// 加载url成功时，根据视频比例渲染播放器
  Widget _isVideoInit() {
    if (_videoInit) {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
    } else if (_videoError) {
      return Text(
        '加载出错',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
  }

  void load() async {
    controller.removeListener(_videoListener);

    /// 加载资源完成时，监听播放进度，并且标记_videoInit=true加载完成
    controller.addListener(_videoListener);
    if (_videoInit || controller.value.isInitialized) {
      if (_destroyed) {
        return;
      }
      setState(() {
        _videoInit = true;
        _videoError = controller.value.hasError;
        controller.play();
      });
      return;
    }
    // 此处不需要等待完成
    await controller.initialize();
    if (_destroyed) {
      return;
    }
    setState(() {
      _videoInit = true;
      _videoError = false;
      controller.play();
    });
  }

  void _videoListener() async {
    if (_destroyed) {
      controller.removeListener(_videoListener);
      return;
    }
    if ((controller.value.isInitialized || controller.value.isPlaying) &&
        !_videoInit) {
      setState(() {
        _videoInit = true;
      });
    }
    if (controller.value.hasError && !_videoError) {
      setState(() {
        _videoError = true;
      });
      return;
    }
    if (!controller.value.hasError) {
      final t = DateTime.now().millisecondsSinceEpoch;
      if (t - render < 800) {
        return;
      }
      render = t;
      Duration? res = await controller.position;
      if (res == null) {
        return;
      }
      if (res >= controller.value.duration) {
        await controller.seekTo(Duration(seconds: 0));
        await controller.pause();
      }
      if (controller.value.isPlaying && _key.currentState != null) {
        /// 减少build次数
        _key.currentState?.setPosition(
          position: res,
          totalDuration: controller.value.duration,
        );
      }
    }
  }
}
