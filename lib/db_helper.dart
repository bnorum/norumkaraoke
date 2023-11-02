import 'dart:async';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper  {
  static Future<void> createTables(Database database) async {
    await database.execute("CREATE TABLE songs(title TEXT PRIMARY KEY, artist TEXT, imgPath TEXT, lyrics TEXT, songPath TEXT)");
  }
  
  static Future<Database> db() async {
    return openDatabase(
      'songs.db',
      version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }



  Future<String> insertSong(Song song) async {
    final db = await DatabaseHelper.db();
    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return song.title;
  }

  Future<List<Song>> songs() async {
    final db = await DatabaseHelper.db();

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
    final db = await DatabaseHelper.db();

    await db.update(
      'songs',
      song.toMap(),
      where: 'title = ?',
      whereArgs: [song.title],
    );
  }

  Future<void> deleteSong(String title) async {
    final db = await DatabaseHelper.db();

    await db.delete(
      'songs',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

 
}




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

  String getImgPath() {
    return imgPath;
  }

}

