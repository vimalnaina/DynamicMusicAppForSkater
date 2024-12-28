import 'package:flutter/foundation.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  // factory LocalDatabase() => _instance;

  LocalDatabase._internal();

  factory LocalDatabase() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'songs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create songs table
        await db.execute('''
          CREATE TABLE songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            songId TEXT UNIQUE,
            name TEXT,
            singer TEXT,
            duration INTEGER,
            difficultyLevel INTEGER,
            createId TEXT,
            createTime TEXT,
            imageId TEXT,
            songUrl TEXT,
            image BLOB,
            song BLOB,
            userId TEXT,
            userName TEXT
          )
        ''');

        // Create song_announcements table
        await db.execute('''
          CREATE TABLE song_announcements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            songId TEXT UNIQUE,
            name TEXT,
            singer TEXT,
            duration INTEGER,
            difficultyLevel INTEGER,
            createId TEXT,
            createTime TEXT,
            imageId TEXT,
            songUrl TEXT,
            image BLOB,
            song BLOB,
            userId TEXT,
            userName TEXT
          )
        ''');

        // Create images table
        await db.execute('''
          CREATE TABLE images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imageId TEXT UNIQUE,
            image BLOB
          )
        ''');
      },
    );
  }

  // Images Table Methods

  Future<int> insertImage(Map<String, dynamic> imageData) async {
    final db = await database;
    return await db.insert('images', imageData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String,dynamic>?> getImageById(String imageId) async {
    final db = await database;
    final maps = await db.query('images', where: 'imageId = ?', whereArgs: [imageId]);

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String,dynamic>>> getAllIMages() async {
    final db = await database;
    final maps = await db.query('images');
    return maps;
  }

  Future<int> deleteImage(String imageId) async {
    final db = await database;
    return await db.delete('images', where: 'imageId = ?', whereArgs: [imageId]);
  }

  // Songs Table Methods

  Future<int> insertSong(SongList song) async {
    final db = await database;
    return await db.insert('songs', song.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<SongList?> getSongById(String songId) async {
    final db = await database;
    final maps = await db.query('songs', where: 'songId = ?', whereArgs: [songId]);

    if (maps.isNotEmpty) {
      return SongList.fromJson(maps.first);
    }
    return null;
  }

  Future<List<SongList>> getAllSongs() async {
    final db = await database;
    final maps = await db.query('songs');
    return List.generate(maps.length, (i) => SongList.fromJson(maps[i]));
  }

  Future<int> deleteSong(String songId) async {
    final db = await database;
    return await db.delete('songs', where: 'songId = ?', whereArgs: [songId]);
  }

  Future<int> updateSong(SongList song) async {
    final db = await database;
    return await db.update(
      'songs',
      song.toJson(),
      where: 'songId = ?',
      whereArgs: [song.songId],
    );
  }

  // SongAnnouncements Table Methods

  Future<int> insertAnnouncement(Map<String, dynamic> announcement) async {
    final db = await database;
    return await db.insert('song_announcements', announcement,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllAnnouncements() async {
    final db = await database;
    return await db.query('song_announcements');
  }

  Future<SongList?> getAnnouncementsBySongId(String songId) async {
    final db = await database;
    // return await db.query(
    //   'song_announcements',
    //   where: 'songId = ?',
    //   whereArgs: [songId],
    // );
    // final db = await database;
    final maps = await db.query('song_announcements', where: 'songId = ?', whereArgs: [songId]);

    if (maps.isNotEmpty) {
      return SongList.fromJson(maps.first);
    }
    return null;
  }

  Future<int> deleteAnnouncement(String announcementId) async {
    final db = await database;
    return await db.delete(
      'song_announcements',
      where: 'announcementId = ?',
      whereArgs: [announcementId],
    );
  }
}
