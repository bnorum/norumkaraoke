import 'package:flutter/material.dart';
import '../karaoke.dart';

const primaryColor = Colors.cyan;
class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  SongListState createState() => SongListState();
}

class Song {
  const Song({required this.title, required this.artist});

  final String title;
  final String artist;
  String getArtist() {return artist;}
  String getTitle() {return title;}

}

class SongListState extends State<SongList> {
  final _songList = [const Song(title:"Margaritaville", artist:"Jimmy Buffet"),
                     const Song(title:"Hotel California", artist:"Eagles"),
                     const Song(title:"Diamonds from Sierra Leone",artist:"Kanye West")];

 
 

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if(item.isOdd) return const Divider();
        final index = item ~/ 2;

        if (index < _songList.length) {return _buildRow(_songList[index]);}
        return null;
      },
    );
  } //_buildlist
  
  
  Widget _buildRow(Song s){
    return ListTile(
      title: Text(s.getTitle(), 
        style: const TextStyle(fontSize: 18.0)
        ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () { pushKaraoke(s); }
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
  void pushKaraoke(Song s) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return KaraokeState(s).build(context);
        }
      )
    );

  }
}