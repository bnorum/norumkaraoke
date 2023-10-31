
import 'song_list.dart';
import '../database.dart';
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

  //WIP: fix textfields not updating
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
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onSaved: (String? value) {
                          if (value != null) {
                            songTitle = value;
                          }
                        },
                      ),
                      Card(
                        child: Padding(
                          padding:EdgeInsets.all(8.0),
                          child:Text(songTitle)
                        )
                      )
                    ]
                  )
                  )]
                
            ),
          )     
        )
      );
    
  }//build
}