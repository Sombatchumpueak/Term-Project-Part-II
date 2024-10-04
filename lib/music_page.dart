import 'package:flutter/material.dart';
import 'package:flutter_application_2/config_data.dart';
import 'models/song.dart';
import 'api_service.dart';
import 'song_detail_page.dart';
import 'edit_song_page.dart'; // เพิ่มการนำเข้า EditSongPage

class MusicPage extends StatelessWidget {
  final Song? selectedSong;

  MusicPage({this.selectedSong});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music'),
      ),
      body: selectedSong != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    selectedSong!.songTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Image.network(
                    selectedSong!.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        image_err_case,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    selectedSong!.artistName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    selectedSong!.genre,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  // เพิ่มปุ่มแก้ไขเพลง
                  ElevatedButton(
                    onPressed: () {
                      // นำทางไปยังหน้าจอแก้ไขเพลงและส่งข้อมูลเพลงที่เลือก
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditSongPage(),
                          settings: RouteSettings(arguments: selectedSong),
                        ),
                      );
                    },
                    child: Text('Edit'),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('No song selected'),
            ),
    );
  }
}
