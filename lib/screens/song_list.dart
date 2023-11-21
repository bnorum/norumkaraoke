import 'dart:io';

import 'package:flutter/material.dart';
import 'karaoke.dart';
import 'add_song.dart';
import 'dart:ui'; 
import 'package:flutter/foundation.dart' show kIsWeb;
import '../db_helper.dart';
import '../ascii_builder.dart';

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
   final list = [const Song(title:"Margaritaville", artist:"Jimmy Buffet",imgPath: 'assets/images/margaritaville.jpg',lyrics: 'assets/lyrics/margaritaville.lrc', songPath: 'music/margaritaville.mp3',),
                     const Song(title:"Hotel California", artist:"Eagles", imgPath:'assets/images/hotelcalifornia.jpg',lyrics: 'assets/lyrics/hotelcalifornia.lrc', songPath: 'music/hotelcalifornia.mp3',),
                     const Song(title:"Be Nice 2 Me",artist:"Bladee", imgPath:'assets/images/icedancer.jpg', lyrics: 'tbd', songPath: 'music/benice2me.mp3',),
                     const Song(title:"Creep",artist:"Radiohead", imgPath:'assets/images/creep.jpg', lyrics: 'assets/lyrics/creep.lrc', songPath: 'music/creep.mp3',)];

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
        _songList = [const Song(title:"Margaritaville", artist:"Jimmy Buffet",imgPath: 'assets/images/margaritaville.jpg',lyrics: 'assets/lyrics/margaritaville.lrc', songPath: 'music/margaritaville.mp3',),
                     const Song(title:"Hotel California", artist:"Eagles", imgPath:'assets/images/hotelcalifornia.jpg',lyrics: 'assets/lyrics/hotelcalifornia.lrc', songPath: 'music/hotelcalifornia.mp3',),
                     const Song(title:"Be Nice 2 Me",artist:"Bladee", imgPath:'assets/images/icedancer.jpg', lyrics: 'tbd', songPath: 'music/benice2me.mp3',),
                     const Song(title:"Creep",artist:"Radiohead", imgPath:'assets/images/creep.jpg', lyrics: 'assets/lyrics/creep.lrc', songPath: 'music/creep.mp3',)];


      }
  }

  

  Widget _buildList() {
    _songList.sort((a,b) => a.CompareTo(b));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if(item == 0 || item == 1) return const SizedBox(height:45);
        if(item.isOdd) return Text("/" * (MediaQuery.of(context).size.width / 8).toInt(), style: TextStyle(color: Colors.white));
        final index = item ~/ 2;

        if (index < _songList.length+1) {return _buildRow(_songList[index-1]);}
        return null;
      },
    );


  } //_buildlist
  
  
  Widget _buildRow(Song s){
    Image SongImage =Image.file(File(s.imgPath));
    if (s.imgPath.contains("assets")) SongImage =Image.asset(s.getImgPath());
    return ListTile(
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SongImage
      ),
      title: Text(s.title, style: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.normal)
        ),
      subtitle: Text(s.artist, style: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.normal)
        ),
      trailing: TextButton(
        child: const Text('Delete', style: TextStyle(fontSize:14,color: Colors.white)),
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
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 20,20,20),
        elevation: 0,
        centerTitle: true,
        //title: const Text('--== Norum_Karaoke ==--', style:TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.normal)),
        title:buildASCII(
              'norum_karaoke', 
              const TextStyle( fontSize: 14, color: Colors.white,
              fontWeight: FontWeight.normal, 
              fontFeatures: [FontFeature.tabularFigures()]), 'assets/ascii/stick_letters.flf'
            ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1.0), child:Align(alignment:Alignment.topLeft,child:Text("  " +"/" * (MediaQuery.of(context).size.width / 8).toInt(), style: const TextStyle(color: Colors.white))))
        ),
    floatingActionButton: FloatingActionButton(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Color.fromARGB(255,20,20,20),
      child: const Column(
        children: [Text('/‾‾‾\\'),Text('| +♪ |'),Text('\\___/')],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
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
        builder: (context) => const AddSong()
      )
    );

  }
}