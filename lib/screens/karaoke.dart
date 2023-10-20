import 'dart:math';
import 'dart:ui';
import 'song_list.dart';
import '../ascii_builder.dart';
import 'package:flutter/material.dart';
import 'package:zwidget/zwidget.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'marglyrics.dart';




class Karaoke extends StatefulWidget {
   Karaoke({Key? key}) : super(key: key);

  @override
  KaraokeState createState() => KaraokeState(const Song(title:"Song 1",artist:"Artist 1",imgPath:"assets/images/margaritaville.jpg"));
  
}



class KaraokeState extends State<Karaoke> with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
  }

  Song _song = const Song(title:"",artist:"",imgPath:"");
  KaraokeState(Song song) {
    _song = song;
  }

  Widget build(BuildContext context) {
   // return titleCard("Brady Norum", _song.title, _song.artist);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(195, 255, 255, 255)),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        title: Text(_song.title, style: const TextStyle(color: Color.fromARGB(70, 255, 255, 255))),
      ),
      body: Stack(children: [...buildBG(), titleCard("Brady Norum",_song.title, _song.artist)],));
  }//build
  

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
    return Column( 
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
        
      );
    
  }//titlecard



  List<Widget> buildBG() {
    return [
      Positioned.fill(
        child: Image.asset(
          "assets/images/beach.jpg",
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      )
    ];
  }


  double sliderProgress = 0;
  int playProgress = 0;
  var lyricAlign = LyricAlign.CENTER;
  var highlightDirection = HighlightDirection.LTR;
  var playing = true;
  AudioPlayer? audioPlayer;
  bool isTap = false;
  bool useEnhancedLrc = false;

  var lyricUI = UINetease();
  var lyricModel = LyricsModelBuilder.create()
      .bindLyricToMain(normalLyric)
      .getModel();
  

  Stack buildReaderWidget() {
    audioPlayer ??= AudioPlayer()..play(AssetSource("music/margaritaville.mp3")); 
    return Stack(
      children: [
        ...buildBG(),
        LyricsReader(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          model: lyricModel,
          lyricUi: lyricUI,
          playing: playing,
          position: playProgress,
          size: Size(double.infinity, MediaQuery.of(context).size.height),
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics",
              style: lyricUI.getOtherMainTextStyle(),
            ),
          ),
          
        ),
        
        
      ],
    );
  }
}