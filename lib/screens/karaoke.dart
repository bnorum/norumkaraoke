import 'package:flutter/material.dart';
class Karaoke extends StatefulWidget {
  const Karaoke({super.key});

  @override
  KaraokeState createState() => KaraokeState();
}

class KaraokeState extends State<Karaoke> {
  
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Norum_Karaoke'),
        ),
      body: const DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.luminosity),
            image: AssetImage("assets/beach.jpg"), fit: BoxFit.cover)
        ),
      ),
    );
  }
  
}