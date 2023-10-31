import 'package:flutter/material.dart';
import 'package:norumkaraoke/theme.dart';
import 'karaoke.dart';
import 'add_song.dart';
import '../creeplyrics.dart';
import 'dart:ui'; 
import '../database.dart';


class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  SongListState createState() => SongListState();
}


class SongListState extends State<SongList> {
  final _songList = [Song(title:"Margaritaville", artist:"Jimmy Buffet",imgPath: 'assets/images/margaritaville.jpg',lyrics: 'tbd', songPath: 'assets/music/margaritaville.mp3',),
                     Song(title:"Hotel California", artist:"Eagles", imgPath:'assets/images/hotelcalifornia.jpg',lyrics: 'tbd', songPath: 'assets/music/margaritaville.mp3',),
                     Song(title:"Diamonds from Sierra Leone",artist:"Kanye West", imgPath:'assets/images/diamondsfromsierraleone.jpg', lyrics: 'tbd', songPath: 'assets/music/margaritaville.mp3',),
                     Song(title:"Be Nice 2 Me",artist:"Bladee", imgPath:'assets/images/icedancer.jpg', lyrics: 'tbd', songPath: 'assets/music/margaritaville.mp3',),
                     Song(title:"Creep",artist:"Radiohead", imgPath:'assets/images/creep.jpg', lyrics: normalLyric, songPath: 'assets/music/creepi.mp3',)];
  
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
      trailing: const Text(">", style: TextStyle(color: Colors.white, fontSize:24)),
      onTap: () { pushKaraoke(); }
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

  void pushKaraoke() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Karaoke()
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