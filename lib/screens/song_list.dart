import 'package:flutter/material.dart';
import 'package:norumkaraoke/theme.dart';
import 'karaoke.dart';
import 'add_song.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  SongListState createState() => SongListState();
}

class Song {
  const Song({required this.title, required this.artist, required this.imgPath});

  final String title;
  final String artist;
  final String imgPath;
  String getArtist() {return artist;}
  String getTitle() {return title;}
  String getImgPath() {return imgPath;}

  int CompareTo(Song other) {
    return title.compareTo(other.title);
  }

}

class SongListState extends State<SongList> {
  final _songList = [const Song(title:"Margaritaville", artist:"Jimmy Buffet", imgPath:'assets/images/margaritaville.jpg'),
                     const Song(title:"Hotel California", artist:"Eagles", imgPath:'assets/images/hotelcalifornia.jpg'),
                     const Song(title:"Diamonds from Sierra Leone",artist:"Kanye West", imgPath:'assets/images/diamondsfromsierraleone.jpg'),
                     const Song(title:"Be Nice 2 Me",artist:"Bladee", imgPath:'assets/images/icedancer.jpg')];

 
 

  Widget _buildList() {
    _songList.sort((a,b) => a.CompareTo(b));
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
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(s.getImgPath())
      ),
      title: Text(s.getTitle(), 
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      subtitle: Text(s.getArtist(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
      onTap: () { pushKaraoke(s); }
    );

  } //_buildrow
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Norum_Karaoke'),
        ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: DarkGreenTheme.primaryColor,
      child: const Icon(Icons.music_note),
      onPressed: () {pushAddSong();},
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

  //DONT DO THIS!!!! 
  void pushAddSong() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddSongState().build(context);
        }
      )
    );

  }
}