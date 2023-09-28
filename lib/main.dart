import 'package:flutter/material.dart';
import './song_list.dart';
void main() { runApp(MyApp());}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      theme: ThemeData(primaryColor: Colors.cyan),
      home: SongList()
    );
  } //build
} //myapp class
