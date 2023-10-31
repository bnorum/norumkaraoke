import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'songs_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE songs(title TEXT PRIMARY KEY, artist TEXT, imgPath TEXT, lyrics TEXT, songPath TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertSong(Song song) async {
    final db = await database;
    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> songs() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('songs');

    return List.generate(maps.length, (i) {
      return Song(
        title: maps[i]['title'] as String,
        artist: maps[i]['artist'] as String,
        imgPath: maps[i]['imgPath'] as String,
        lyrics: maps[i]['lyrics'] as String,
        songPath: maps[i]['songPath'] as String,
      );
    });
  }

  Future<void> updateSong(Song song) async {
    final db = await database;

    await db.update(
      'songs',
      song.toMap(),
      where: 'title = ?',
      whereArgs: [song.title],
    );
  }

  Future<void> deleteSong(String title) async {
    final db = await database;

    await db.delete(
      'songs',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  var margaritaville = const Song(
    title: 'Margaritaville',
    artist: 'Jimmy Buffet',
    imgPath: 'assets/images/margaritaville.jpg',
    lyrics: 'tbd',
    songPath: 'assets/music/margaritaville.mp3',
  );
}//main





class Song {
  final String title;
  final String artist;
  final String imgPath;
  final String lyrics;
  final String songPath;
  const Song({required this.title, required this.artist, required this.imgPath , required this.lyrics, required this.songPath});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'imgPath': imgPath,
      'lyrics': lyrics,
      'songPath': songPath,
    };
  }

  @override
  String toString() {
    return 'Song{title: $title, artist: $artist, imgPath: $imgPath, lyrics: $lyrics, songPath: $songPath}';
  }

  int CompareTo(Song other) {
    return title.compareTo(other.title);
  }

}

