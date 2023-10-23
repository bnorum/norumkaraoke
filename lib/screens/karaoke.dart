import 'dart:math';
import 'dart:ui';
import 'song_list.dart';
import '../ascii_builder.dart';
import 'package:flutter/material.dart';
import 'package:zwidget/zwidget.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'creeplyrics.dart';




class Karaoke extends StatefulWidget {
  @override
  KaraokeState createState() => KaraokeState();
}



class KaraokeState extends State<Karaoke> with SingleTickerProviderStateMixin {
  Song _song = const Song(title:"",artist:"",imgPath:"");
  
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
      //body: Stack(children: [...buildBG(), titleCard("Brady Norum",_song.title, _song.artist)],));
      body: SingleChildScrollView(child:Stack(children: [...buildBG(), buildReaderAndPlay()])));
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

  var lyricUI = UINetease();
  var lyricModel = LyricsModelBuilder.create()
      .bindLyricToMain(normalLyric)
      .getModel();
  

  Stack buildReaderWidget() {
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

  List<Widget> buildPlayControl() {
    return [
      Container(
        height: 20,
      ),
      if (sliderProgress < max_value)
        Slider(
          min: 0,
          max: max_value,
          label: sliderProgress.toString(),
          value: sliderProgress,
          activeColor: Colors.blueGrey,
          inactiveColor: Colors.blue,
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
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                if (audioPlayer == null) {
                  audioPlayer = AudioPlayer()..play(AssetSource("music/creep.mp3"));
                  setState(() {
                    playing = true;
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
                }
              },
              child: Text("Play")),
          Container(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                audioPlayer?.pause();
              },
              child: Text("Pause")),
          Container(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                audioPlayer?.stop();
                audioPlayer = null;
              },
              child: Text("Stop")),
        ],
      ),
    ];
  }


  Widget buildReaderAndPlay() {
    return Column(children:[buildReaderWidget(), ...buildPlayControl()]);

  }
}