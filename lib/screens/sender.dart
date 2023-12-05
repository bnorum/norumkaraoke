import '../db_helper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Sender extends StatefulWidget {
  
  const Sender({super.key, required this.song});

  final Song song;

  @override
  // ignore: no_logic_in_create_state
  SenderState createState() => SenderState(song);
}

class SenderState extends State<Sender> {
  int code = 000000;
  late Song _song;

  SenderState(Song song) {
    this._song = song;
  }

  String lyricUrl = '';
  String soundUrl = '';
  CollectionReference _reference = FirebaseFirestore.instance.collection('codexd');
  GlobalKey<FormState> key = GlobalKey();


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: const Text("<", style: TextStyle(color: Colors.white, fontSize:14)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        centerTitle: true,
        title: const Text('Send to Coda', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(5.0), child:Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1), style: const TextStyle(color: Colors.white)))
        ),
      body: Center( 
        child: Column(
          children: [
            Text("Enter Code below to send song to Coda", style: const TextStyle(color: Colors.white)),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Code',
              ),
              onChanged: (value) {
                setState(() {
                   _reference = FirebaseFirestore.instance.collection(value);
                  code = int.parse(value);
                });
              },
            ),
            TextButton(
              child: const Text("Upload"),
              onPressed: () async {
                final soundFile = File(_song.songPath); 
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirCode = referenceRoot.child(code.toString());
                Reference referenceSoundToUpload = referenceDirCode.child(soundFile.path.split('/').last);

                
                try {
                  //Store the file
                  await referenceSoundToUpload.putFile(soundFile);
                  //Success: get the download URL
                  soundUrl = await referenceSoundToUpload.getDownloadURL();
                } catch (error) {
                  //Some error occurred
                  print(error);
                }
              },
            ),
            TextButton(
              child: const Text("Send"),
              onPressed: () async {
                      //Create a Map of data
                      final lyricFile = File(_song.lyrics);
                      print(lyricFile.toString());
                      Map<String, String> dataToSend = {
                        'lyric': await lyricFile.readAsString(), //just dump contents of lyric file lol
                        'sound': soundUrl,
                      };

                      //Add a new item
                      _reference.add(dataToSend);
                
                  
              },
            ),
          ]
        )

      )
    );
  }
}
