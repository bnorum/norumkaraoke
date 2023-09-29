import 'dart:math';
import 'dart:ui';
import 'screens/song_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwidget/zwidget.dart';
import 'package:enough_ascii_art/enough_ascii_art.dart';





class Karaoke extends StatefulWidget {
  const Karaoke({super.key});

  @override
  KaraokeState createState() => KaraokeState(Song(title:"",artist:""));
  
}



class KaraokeState extends State<Karaoke>{
  Song _song = Song(title:"",artist:"");
  KaraokeState(Song song) {
    _song = song;
  }

  Widget build(BuildContext context) {
    return titleCard("Brady Norum", _song.title, _song.artist);
  }//build

  Future<String> fetchCreateText(String thisText, String path) async {
    var file = await rootBundle.loadString(path);
    var figure = renderFiglet(thisText, Font.text(file));
    return figure;
  }

  Widget buildASCII(String thisText, TextStyle text, String path) { //future builder associated with ascii text
    return FutureBuilder(
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: FittedBox(fit: BoxFit.fitWidth,child:Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  )),
                );
              } else if (snapshot.hasData) { //if fetchCreateText works:
                final data = snapshot.data as String;
                return Center(
                  child: Text(
                    '$data',
                    style: text,
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          future: fetchCreateText(thisText, path),
        );
  }//build ascii

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
      midChild:buildASCII(name, const TextStyle( color: Colors.red,fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()]), 'assets/ascii/smslant.flf'),
      midToBotChild: buildASCII(name, const TextStyle( color: Colors.black),'assets/ascii/smslant.flf'),
      rotationX: pi / 18,
      layers: 8,
      depth: 32,
    );
  }


  Widget titleCard(String playerName, String songName, String artistName) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(76, 255, 255, 255)),
        backgroundColor: const Color(0x44000000),
        elevation: 0,
        title: Text(songName, style: const TextStyle(color: Color.fromARGB(76, 255, 255, 255))
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
