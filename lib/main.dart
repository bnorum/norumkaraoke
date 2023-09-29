import 'package:flutter/material.dart';
import 'screens/song_list.dart';
import 'package:flutter/services.dart';
void main() { runApp(MyApp());}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp( 
      theme: ThemeData(primaryColor: Colors.cyan, fontFamily: 'consolas'), 
      home: SongList()
    );
  } //build
} //myapp class
