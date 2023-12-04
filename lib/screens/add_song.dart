import 'package:file_picker/file_picker.dart';
import '../db_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';



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
  var songPath = "";
  DatabaseHelper dbHelper = DatabaseHelper();
  FilePickerResult? resultImg;
  FilePickerResult? resultSong;
  FilePickerResult? resultLyrics; //temporary!

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
        title: const Text('Add A Song', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(5.0), child:Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1), style: const TextStyle(color: Colors.white)))
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
                      const Text('Song Title',style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal)),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      TextFormField(
                        decoration: 
                          const InputDecoration(
                            enabledBorder: 
                              OutlineInputBorder(
                                borderSide: 
                                  BorderSide(
                                    color: Color.fromRGBO(18, 18, 18, 0), 
                                    width: 0.0),
                              ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter a Song Title',
                          ),
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                        onSaved: (String? value) {
                          if (value != null) {
                            songTitle = value;
                          }
                        },
                      ),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      
                      const Text('Song Artist',style: TextStyle(color: Colors.white),),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      TextFormField(
                        decoration: 
                          const InputDecoration(
                            enabledBorder: 
                              OutlineInputBorder(
                                borderSide: 
                                  BorderSide(
                                    color: Color.fromRGBO(18, 18, 18, 0), 
                                    width: 0.0),
                              ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter a Song Artist',
                          ),
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                        onSaved: (String? value) {
                          if (value != null) {
                            songArtist = value;
                          }
                        },
                      ),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      
                      const Text('Image Path',style: TextStyle(color: Colors.white),),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      /*
                      TextFormField(
                        decoration: 
                          const InputDecoration(
                            enabledBorder: 
                              OutlineInputBorder(
                                borderSide: 
                                  BorderSide(
                                    color: Color.fromRGBO(18, 18, 18, 0), 
                                    width: 0.0),
                              ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter an image path',
                          ),
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                        onSaved: (String? value) {
                          if (value != null) {
                            songImgPath = value;
                          }
                        },
                      ),
                      */
                      //FIX THIS!!!
                      ElevatedButton(
                        onPressed: () async {
                          Directory dir = await getApplicationDocumentsDirectory();
                          final String appdirpath = dir.path;
                          
                          resultImg = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: ['png', 'jpg', 'jpeg'],
                            type: FileType.custom,
                          );
                          if (resultImg != null) {
                            PlatformFile file = resultImg!.files.first;
                            final File toFile = File(file.path!);
                            final File copiedFile = await toFile.copy('$appdirpath/${file.name}');
                            setState(() {
                              songImgPath = copiedFile.path;
                            });
                          } else {
                            print("No file selected");
                          }
                        }, 
                        child: Text("Select Image from Files")),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      
                      const Text('Lyrics Upload [temporary]',style: TextStyle(color: Colors.white),),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      ElevatedButton(
                        onPressed: () async {
                          Directory dir = await getApplicationDocumentsDirectory();
                          final String appdirpath = dir.path;
                          resultLyrics = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          if (resultLyrics != null) {
                            PlatformFile file = resultLyrics!.files.first;
                            final File toFile = File(file.path!);
                            final File copiedFile = await toFile.copy('$appdirpath/${file.name}');
                            setState(() {
                              songLyricsPath = copiedFile.path;
                            });
                          } else {
                            print("No file selected");
                          }
                        }, 
                        child: Text("Select .lrc from Files")),
                      /*
                      TextFormField(
                        decoration: 
                          const InputDecoration(
                            enabledBorder: 
                              OutlineInputBorder(
                                borderSide: 
                                  BorderSide(
                                    color: Color.fromRGBO(18, 18, 18, 0), 
                                    width: 0.0),
                              ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter a lyric path',
                          ),
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                        onSaved: (String? value) {
                          if (value != null) {
                            songLyricsPath = value;
                          }
                        },
                      ),
                      */
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      
                      const Text('Song Path',style: TextStyle(color: Colors.white),),
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      ElevatedButton(
                        onPressed: () async {
                          Directory dir = await getApplicationDocumentsDirectory();
                          final String appdirpath = dir.path;
                          resultSong = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: ['mp3'],
                            type: FileType.custom,
                          );
                          if (resultSong != null) {
                            PlatformFile file = resultSong!.files.first;
                            final File toFile = File(file.path!);
                            final File copiedFile = await toFile.copy('$appdirpath/${file.name}');
                            setState(() {
                              songPath = copiedFile.path;
                            });
                          } else {
                            print("No file selected");
                          }
                        }, 
                        child: Text("Select Song from Files")),
                      /*
                      TextFormField(
                        decoration: 
                          const InputDecoration(
                            enabledBorder: 
                              OutlineInputBorder(
                                borderSide: 
                                  BorderSide(
                                    color: Color.fromRGBO(18, 18, 18, 0), 
                                    width: 0.0),
                              ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter an song path',
                          ),
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                        onSaved: (String? value) {
                          if (value != null) {
                            songPath = value;
                          }
                        },
                      ),
                      */
                      Text("-" * ((MediaQuery.of(context).size.width ~/ 8)-1),style: const TextStyle(color: Colors.white),),
                      
                      ElevatedButton(
                      style:ButtonStyle(elevation:MaterialStatePropertyAll<double>(0),backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(0, 0, 0, 0))),
                      child: const Column(
                        children: [Text('/‾‾‾\\'),Text('| +♪ |'),Text('\\___/')],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      
                        onPressed: () {
                          Song s = Song(title: songTitle, artist: songArtist, imgPath: songImgPath, lyrics: songLyricsPath, songPath: songPath);
                          dbHelper.insertSong(s);
                          Navigator.pop(context);
                        },
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