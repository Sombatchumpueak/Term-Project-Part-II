import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Song {
  String id;
  String songTitle;
  String artistName;
  String album;
  String genre;
  String image; // Optional if you want to manage images

  Song({
    required this.id,
    required this.songTitle,
    required this.artistName,
    required this.album,
    required this.genre,
    required this.image,
  });

  // Convert a Song object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'songTitle': songTitle,
      'artistName': artistName,
      'album': album,
      'genre': genre,
      'image': image,
    };
  }

  // Create a Song object from a Map
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      songTitle: json['songTitle'],
      artistName: json['artistName'],
      album: json['album'],
      genre: json['genre'],
      image: json['image'], // Provide a default if not present
    );
  }
}

// ฟังก์ชันสำหรับอ่านเพลงจาก data.json
Future<List<Song>> readSongs() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/data.json';
    final file = File(path);

    if (!file.existsSync()) {
      return []; // ถ้าไฟล์ไม่มี ให้ส่งกลับเป็น list ว่าง
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = json.decode(jsonString)['songs'];
    return jsonList.map((json) => Song.fromJson(json)).toList();
  } catch (e) {
    print("Error reading songs: $e");
    return []; // ส่งกลับ list ว่างในกรณีเกิดข้อผิดพลาด
  }
}

// ฟังก์ชันสำหรับเพิ่มเพลงใหม่
Future<void> addSong(Song song) async {
  try {
    final songs = await readSongs();

    // ตรวจสอบว่า ID ของเพลงใหม่ไม่ซ้ำกับเพลงที่มีอยู่
    if (songs.any((existingSong) => existingSong.id == song.id)) {
      print("Song with ID ${song.id} already exists.");
      return; // ถ้ามีเพลงนี้อยู่แล้ว ไม่ต้องเพิ่ม
    }

    songs.add(song); // เพิ่มเพลงใหม่ในรายการ

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/data.json';
    final file = File(path);

    // บันทึกข้อมูลเพลงทั้งหมดกลับไปที่ data.json
    await file.writeAsString(
        json.encode({'songs': songs.map((s) => s.toJson()).toList()}));

    print("Added song: ${song.songTitle}");
  } catch (e) {
    print("Error adding song: $e");
  }
}

// ฟังก์ชันสำหรับแก้ไขเพลง
Future<void> editSong(Song updatedSong) async {
  try {
    final songs = await readSongs();

    for (var i = 0; i < songs.length; i++) {
      if (songs[i].id == updatedSong.id) {
        songs[i] = updatedSong; // แก้ไขเพลงที่ตรงกับ ID
        break; // ออกจากลูปเมื่อแก้ไขเสร็จ
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/data.json';
    final file = File(path);

    // บันทึกข้อมูลเพลงทั้งหมดกลับไปที่ data.json
    await file.writeAsString(
        json.encode({'songs': songs.map((s) => s.toJson()).toList()}));

    print("Edited song: ${updatedSong.songTitle}");
  } catch (e) {
    print("Error editing song: $e");
  }
}
