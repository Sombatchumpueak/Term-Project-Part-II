import 'package:flutter/material.dart';
import 'package:flutter_application_2/config_data.dart';
import 'models/song.dart';

class SongDetailPage extends StatelessWidget {
  final Song song;

  SongDetailPage({required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.songTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // แสดงชื่อเพลงที่เลือก
            Text(
              song.songTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // แสดงภาพที่เกี่ยวข้องกับเพลง
            Image.network(
              song.image,
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

            // แสดงชื่อศิลปิน
            Text(
              song.artistName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),

            // แสดงแนวเพลง
            Text(
              song.genre,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 32),

            // เพิ่มปุ่มเล่นเพลง และอื่นๆ ตามดีไซน์ที่คุณต้องการ
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
          ],
        ),
      ),
    );
  }
}
