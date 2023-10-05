import 'dart:math';
import 'dart:ui';
import 'song_list.dart';
import '../ascii_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwidget/zwidget.dart';





class Karaoke extends StatefulWidget {
  const Karaoke({super.key});

  @override
  KaraokeState createState() => KaraokeState(Song(title:"",artist:"",imgPath:"assets/images/margaritaville.jpg"));
  
}



class KaraokeState extends State<Karaoke>{
  Song _song = Song(title:"",artist:"",imgPath:"");
  KaraokeState(Song song) {
    _song = song;
  }

  Widget build(BuildContext context) {
    return titleCard("Brady Norum", _song.title, _song.artist);
  }//build

  

  //build ascii

  Widget topTitle(String name) {
    return ZWidget.backwards(
      midChild:buildASCII(name, const TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()]), 'assets/ascii/basic.flf'),
      midToBotChild: buildASCII(name, const TextStyle( color: Colors.black),'assets/ascii/basic.flf'),
      rotationX: -pi / 18,
      layers: 8,
      depth: 32,
    );
  }

  Widget bottomTitle(String name) {
    return ZWidget.backwards(
      midChild:buildASCII(name, const TextStyle( color: Colors.red,fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()]), 'assets/ascii/stick_letters.flf'),
      midToBotChild: buildASCII(name, const TextStyle( color: Colors.black),'assets/ascii/stick_letters.flf'),
      rotationX: pi / 18,
      layers: 8,
      depth: 32,
    );
  }


  Widget titleCard(String playerName, String songName, String artistName) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(195, 255, 255, 255)),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        title: Text(songName, style: const TextStyle(color: Color.fromARGB(70, 255, 255, 255))
      ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.luminosity),
            image: AssetImage("assets/images/beach.jpg"), fit: BoxFit.cover)
            
        ),
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            topTitle(playerName),
            const Text('versus', 
              style:TextStyle(
                fontSize:18, 
                color:Colors.white,
                fontWeight: FontWeight.bold,
                fontFeatures: [
                  FontFeature.tabularFigures(),
                ]
              ),
              ),
            bottomTitle(songName),
            Text('by ${artistName}', 
              style:const TextStyle(
                fontSize:18, 
                color:Colors.white, 
                fontWeight: FontWeight.bold
              )
            ),
          ]
        )
      )
    );
  }
}
