import 'package:flutter/material.dart';
import 'cover_page.dart';
import 'home_page.dart';
import 'add_song_page.dart';
import 'edit_song_page.dart';
import 'music_page.dart'; // เพิ่ม import หน้านี้

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => CoverPage(),
        '/home': (context) => HomePage(),
        '/add': (context) => AddSongPage(),
        '/edit': (context) => EditSongPage(),
        '/music': (context) => MusicPage(), // เพิ่ม route สำหรับหน้า Music
      },
    );
  }
}
