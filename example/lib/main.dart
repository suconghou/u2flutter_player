import 'package:flutter/material.dart';
import 'package:u2flutter_player/u2flutter_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatelessWidget {
//  Size get _window => MediaQueryData.fromWindow(window).size;

  @override
  Widget build(BuildContext context) {
    final url = "http://share.suconghou.cn/video/mrHqzfjdpX8.mpd";
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        // 该组件宽高默认填充父控件，你也可以自己设置宽高
        child: SizedBox(
          height: 300,
          width: 300,
          child: VideoPlayerUI(opts: PlayerOpts(url)),
        ),
      ),
    );
  }
}
