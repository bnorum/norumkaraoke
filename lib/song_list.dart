import 'package:flutter/material.dart';
import 'main.dart';
import "dart:math";



const primaryColor = Colors.cyan;
class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  SongListState createState() => SongListState();
}//randomwords class

class Song {
  const Song({required this.title, required this.artist});

  final String title;
  final String artist;
  String getArtist() {return artist;}
  String getTitle() {return title;}

}

class SongListState extends State<SongList> {
  final _songList = [Song(title:"Margaritaville", artist:"Jimmy Buffet"),
                     Song(title:"Hotel California", artist:"Eagles"),
                     Song(title:"Diamonds from Sierra Leone",artist:"Kanye West")];


  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if(item.isOdd) return const Divider();
        final index = item ~/ 2;

       
        return _buildRow(_songList[index]);
      },
    );
  } //_buildlist
  
  
  Widget _buildRow(Song s){
    

    return ListTile(
      title: Text(s.getTitle(), 
        style: const TextStyle(fontSize: 18.0)
        ),
      trailing: Text(s.getArtist(), 
        style: const TextStyle(fontSize: 18.0)
        ),
    );

  } //_buildrow
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('Norum_Karaoke'),
        ),
        
      body: _buildList()
    );
  }//build

}