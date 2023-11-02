
import 'song_list.dart';
import '../db_helper.dart';
import 'package:flutter/material.dart';



class AddSong extends StatefulWidget {
  const AddSong({super.key});

  @override
  AddSongState createState() => AddSongState();
  
}

class AddSongState extends State<AddSong> {
  @override
  void initState() {
    super.initState();
  }

  var songTitle = "";
  var songArtist = "";
  var songImgPath = "";
  var songLyricsPath = "";
  var songCoverPath = "";
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Norum_Karaoke'),
        ),
      body:SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          onChanged: () {
            setState(() {
            Form.of(primaryFocus!.context!).save();
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Song Title'),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onSaved: (String? value) {
                          if (value != null) {
                            songTitle = value;
                          }
                        },
                      ),
                      const Text('Song Artist'),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onSaved: (String? value) {
                          if (value != null) {
                            songArtist = value;
                          }
                        },
                      ),
                      const Text('Image Path'),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onSaved: (String? value) {
                          if (value != null) {
                            songImgPath = value;
                          }
                        },
                      ),
                      const Text('Lyrics Path'),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onSaved: (String? value) {
                          if (value != null) {
                            songLyricsPath = value;
                          }
                        },
                      ),
                      const Text('Cover Path'),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onSaved: (String? value) {
                          if (value != null) {
                            songCoverPath = value;
                          }
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Song s = Song(title: songTitle, artist: songArtist, imgPath: songImgPath, lyrics: songLyricsPath, songPath: songCoverPath);
                          dbHelper.insertSong(s);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SongList()),
                          );
                        },
                        child: const Text('Submit'),
                      ),
                    ]
                  )
                  )]
                
            ),
          )     
        )
      );
    
  }//build
}