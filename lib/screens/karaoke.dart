import 'dart:math';
import 'dart:ui';
import 'dart:io';
import '../ascii_builder.dart';
import '../lyricstyle.dart'; 
import 'package:flutter/material.dart';
import 'package:zwidget/zwidget.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../db_helper.dart';
import '../nolyricsfound.dart';

import 'package:flutter/foundation.dart' show kIsWeb;



class Karaoke extends StatefulWidget {

  const Karaoke({super.key, required this.song});
  
  final Song song;

  @override
  KaraokeState createState() => KaraokeState(song);
}



class KaraokeState extends State<Karaoke> with SingleTickerProviderStateMixin {
  late Song _song;
  String lyricstemp = "a";
  var lyricModel = LyricsModelBuilder.create()
      .bindLyricToMain(normalLyric)
      .getModel();
  
  KaraokeState(Song song) {
    this._song = song;

  }
    
  String lyrics = "";

  @override
  void initState() {
 
    super.initState();
       if (kIsWeb){
        lyricUI = norumLyricUI(otherMainSize: 40,defaultExtSize: 40,defaultSize: 40,lineGap:2000);
        }
    initLyricModel();
    getLyric(_song).then((value) {
      setState(() {
        lyrics = value;
      });}
      );
  }

  void initLyricModel() async {
  lyrics = await getLyric(_song);
  lyricModel = LyricsModelBuilder.create()
      .bindLyricToMain(lyrics)
      .getModel();
  }
  Future<String> getLyric(Song s) async {
    return await rootBundle.loadString(s.lyrics);
    //return File(directory.path + "/" + s.lyrics).readAsString();
  }

  

  Widget build(BuildContext context) {
   // return titleCard("Brady Norum", _song.title, _song.artist);
    return Scaffold(
      
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: TextButton(
          child: Text("<", style: TextStyle(color: Colors.white, fontSize:24)),
          onPressed: () {
            audioPlayer?.stop();
            audioPlayer = null;
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(195, 255, 255, 255)),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        title: Text(_song.title, style: const TextStyle(color: Color.fromARGB(70, 255, 255, 255))),
      ),
      //body: Stack(children: [...buildBG(), titleCard("Brady Norum",_song.title, _song.artist)],));
      body: Stack(children: [...buildBG(), buildReaderAndPlay()]));
  }//build
  

  //ascii title stuff:
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
            fontFeatures: [FontFeature.tabularFigures()]
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
  //ascii title stuff


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
  double max_value = 211658;
  var lyricAlign = LyricAlign.CENTER;
  var highlightDirection = HighlightDirection.LTR;
  var playing = false;
  AudioPlayer? audioPlayer;
  bool isTap = false;
  bool useEnhancedLrc = false;
  var lyricUI = norumLyricUI(lineGap:2000);
  
  

  Widget buildReaderWidget() {
    return 
        LyricsReader(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          model: lyricModel,
          lyricUi: lyricUI,
          playing: playing,
          position: playProgress,
          size: Size(double.infinity, MediaQuery.of(context).size.height),
          emptyBuilder: () => const Center(
            child: Text("No lyrics"),
          ),
          
        );
  }

  var controlsOpacity = .45;
  List<Widget> buildPlayControl() {
    return [
      if (sliderProgress < max_value)
        Opacity(opacity:controlsOpacity,child:Slider(
          min: 0,
          max: max_value,
          label: sliderProgress.toString(),
          value: sliderProgress,
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          onChanged: (double value) {
            setState(() {
              sliderProgress = value;
            });
          },
          onChangeStart: (double value) {
            isTap = true;
          },
          onChangeEnd: (double value) {
            isTap = false;
            setState(() {
              playProgress = value.toInt();
            });
            audioPlayer?.seek(Duration(milliseconds: value.toInt()));
          },
        )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory
              ),
              onPressed: () async {
                if (audioPlayer == null  && mounted) {
                  var source = DeviceFileSource(_song.songPath);
                  if (!_song.songPath.contains("app_flutter")) {audioPlayer = AudioPlayer()..play(AssetSource(_song.songPath)); }
                  else audioPlayer = AudioPlayer()..play(source);
                  setState(() {
                    playing = true;
                    controlsOpacity = 0;
                  });
                  audioPlayer?.onDurationChanged.listen((Duration event) {
                    setState(() {
                      max_value = event.inMilliseconds.toDouble();
                    });
                  });
                  audioPlayer?.onPositionChanged.listen((Duration event) {
                    if (isTap) return;
                    setState(() {
                      sliderProgress = event.inMilliseconds.toDouble();
                      playProgress = event.inMilliseconds;
                    });
                  });

                  audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
                    setState(() {
                      playing = state == PlayerState.playing;
                    });
                  });
                } else {
                  audioPlayer?.resume();
                  controlsOpacity = 0;
                }
              },
              child: Opacity(opacity: controlsOpacity, child:const Text("|>", style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)))),
          Container(
            width: 10,
          ),
          TextButton(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory
              ),
              onPressed: () async {
                audioPlayer?.pause();
                controlsOpacity = .45;
              },
              child: Opacity(opacity: .40, child:const Text("||", style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)))),
          Container(
            width: 10,
          ),
          TextButton(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory
              ),
              onPressed: () async {
                audioPlayer?.stop();
                audioPlayer = null;
              },
              child: Opacity(opacity: controlsOpacity, child:const Text("■", style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)))),
        ],
      ),
    ];
  }//buildPlayControl


  Widget buildReaderAndPlay() {
    return Column(children:[Container(height: MediaQuery.of(context).size.height * .60, child:buildReaderWidget()), ...buildPlayControl()]);
  }
}