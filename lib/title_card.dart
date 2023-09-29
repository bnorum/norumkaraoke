import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwidget/zwidget.dart';
import 'package:enough_ascii_art/enough_ascii_art.dart';
void main() {
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> fetchCreateText(String thisText) async {
    var file = await rootBundle.loadString('assets/smslant.flf');
    var figure = renderFiglet(thisText, Font.text(file));
    return figure;
  }

  Widget buildASCII(String thisText, TextStyle text) { //future builder associated with ascii text
    return FutureBuilder(
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
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
          future: fetchCreateText(thisText),
        );
  }//build ascii

  Widget topTitle(String name) {
    return ZWidget.backwards(
      midChild:buildASCII(name, const TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)),
      midToBotChild: buildASCII(name, const TextStyle(fontSize: 18, color: Colors.black)),
      rotationX: -pi / 18,
      layers: 8,
      depth: 32,
    );
  }
  Widget bottomTitle(String name) {
    return ZWidget.backwards(
      midChild:buildASCII(name, const TextStyle(fontSize: 18, color: Colors.red,fontWeight: FontWeight.bold)),
      midToBotChild: buildASCII(name, const TextStyle(fontSize: 18, color: Colors.black)),
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
        const Text('versus', style:TextStyle(fontSize:18, color:Colors.white,fontWeight: FontWeight.bold)),
        bottomTitle(songName),
          Text('by ${artistName ?? ''}', style:TextStyle(fontSize:18, color:Colors.white, fontWeight: FontWeight.bold)),
      ]
    );
  }
  
  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      theme: ThemeData(fontFamily: 'consolas'),
      home: Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.luminosity),
            image: AssetImage("assets/beach.jpg"), fit: BoxFit.cover)
            
        ),
        child: titleCard('Brady Norum', 'Margaritaville', 'Jimmy Buffet')
        
      ),
      ),
    );
  }
}


