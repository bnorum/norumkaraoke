import 'dart:io';

import 'package:flutter/material.dart';
import 'karaoke.dart';
import 'add_song.dart';
import 'dart:ui'; 
import 'package:flutter/foundation.dart' show kIsWeb;
import '../db_helper.dart';


class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  SongListState createState() => SongListState();
}


class SongListState extends State<SongList> {
  List<Song> _songList = [];
  DatabaseHelper dbHelper = DatabaseHelper();

  void addBaseSongs() async {
  DatabaseHelper dbHelper = DatabaseHelper();
   final list = [Song(title:"Margaritaville", artist:"Jimmy Buffet",imgPath: 'assets/images/margaritaville.jpg',lyrics: 'assets/lyrics/margaritaville.lrc', songPath: 'music/margaritaville.mp3',),
                     Song(title:"Hotel California", artist:"Eagles", imgPath:'assets/images/hotelcalifornia.jpg',lyrics: 'assets/lyrics/hotelcalifornia.lrc', songPath: 'music/hotelcalifornia.mp3',),
                     Song(title:"Be Nice 2 Me",artist:"Bladee", imgPath:'assets/images/icedancer.jpg', lyrics: 'tbd', songPath: 'music/benice2me.mp3',),
                     Song(title:"Creep",artist:"Radiohead", imgPath:'assets/images/creep.jpg', lyrics: 'assets/lyrics/creep.lrc', songPath: 'music/creep.mp3',)];

    for (var song in list) {

      await dbHelper.insertSong(song);
      await dbHelper.updateSong(song);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb){
    addBaseSongs();
    dbHelper.songs().then((value) {
      setState(() {
        _songList = value;
      });}
      );}
      else {
        //for live demo only, will get a better solution for final. SQLite doesnt work in browser ):
        _songList = [Song(title:"Margaritaville", artist:"Jimmy Buffet",imgPath: 'assets/images/margaritaville.jpg',lyrics: 'assets/lyrics/margaritaville.lrc', songPath: 'music/margaritaville.mp3',),
                     Song(title:"Hotel California", artist:"Eagles", imgPath:'assets/images/hotelcalifornia.jpg',lyrics: 'assets/lyrics/hotelcalifornia.lrc', songPath: 'music/hotelcalifornia.mp3',),
                     Song(title:"Be Nice 2 Me",artist:"Bladee", imgPath:'assets/images/icedancer.jpg', lyrics: 'tbd', songPath: 'music/benice2me.mp3',),
                     Song(title:"Creep",artist:"Radiohead", imgPath:'assets/images/creep.jpg', lyrics: 'assets/lyrics/creep.lrc', songPath: 'music/creep.mp3',)];


      }
  }

  

  Widget _buildList() {
    _songList.sort((a,b) => a.CompareTo(b));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if(item == 0 || item == 1) return SizedBox(height:35);
        if(item.isOdd) return Text("-" * (MediaQuery.of(context).size.width / 8).toInt());
        final index = item ~/ 2;

        if (index < _songList.length+1) {return _buildRow(_songList[index-1]);}
        return null;
      },
    );


  } //_buildlist
  
  
  Widget _buildRow(Song s){
    return ListTile(
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(s.getImgPath())
      ),
      title: Text(s.title, 
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      subtitle: Text(s.artist,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          await dbHelper.deleteSong(s.title);
          setState(() {
            _songList.remove(s);
          });
        },
      ),
      onTap: () { pushKaraoke(s); }
    );

  } //_buildrow
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        centerTitle: true,
        title: const Text('Norum_Karaoke'),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(5.0), child:Text("-" * (MediaQuery.of(context).size.width / 8).toInt(), style: TextStyle(color: Colors.white)))
        ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.grey,
      child: const Icon(Icons.music_note),
      onPressed: () {pushAddSong();},
    ),
      body: _buildList()
    );
  }//build

  void pushKaraoke(Song song) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Karaoke(song:song)
      )
    );

  }
  void pushAddSong() { 
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddSong()
      )
    );

  }
}