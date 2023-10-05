import 'package:flutter/material.dart';
import 'screens/song_list.dart';
import 'theme.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'ascii_builder.dart';
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
      theme: DarkGreenTheme.themeData, 
      title: 'Splash Screen',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  } //build
} //myapp class

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}
class SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => const SongList())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child:Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            buildASCII(
              'norum_karaoke', 
              const TextStyle( color: DarkGreenTheme.textColor,
              fontWeight: FontWeight.bold, 
              fontFeatures: [FontFeature.tabularFigures()]), 'assets/ascii/smslant.flf'
            ),
            buildASCII(
              'NK', 
              const TextStyle( color: Colors.white,
              fontWeight: FontWeight.bold, 
              fontFeatures: [FontFeature.tabularFigures()]), 'assets/ascii/basic.flf'
            )
          ]
        ),
      )
    );
  }//build
}