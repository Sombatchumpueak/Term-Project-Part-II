import 'package:flutter/material.dart';
import 'package:flutter_application_2/api_service.dart';
import 'package:flutter_application_2/config_data.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // สำหรับการจัดการไฟล์
import 'dart:convert'; // สำหรับการแปลงไฟล์เป็น Base64
import 'package:path_provider/path_provider.dart'; // สำหรับหาไดเรกทอรี
import 'models/song.dart'; // สำหรับ Song โมเดล
import 'dart:async';
import 'package:http/http.dart' as http;

class AddSongPage extends StatefulWidget {
  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  late String _id;
  String _artist = '';
  String _album = '';
  String _genre = '';
  String _urlImg = '';
  bool enable_add = true;
  File? _imageFile; // เก็บไฟล์รูปภาพที่เลือก
  String imgShow = image_err_case;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchSongData(); // Call the function when the widget initializes
  }

  Future<void> fetchSongData() async {
    // Make HTTP GET request
    final url = Uri.parse('${data_config}/songs');
    try {
      final response = await http.get(
        url, // ใช้คำสั่ง get แทน
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON data
        final List<dynamic> data = json.decode(response.body);
        // Loop through data and extract the 'id' values
        List<String> ids = data.map((song) => song['id'] as String).toList();

// Find the maximum ID value (assuming the IDs are comparable strings)
        String maxId =
            ids.reduce((curr, next) => curr.compareTo(next) > 0 ? curr : next);

        // Generate new ID without the 'Ms' prefix
        String newId = (int.parse(maxId.substring(2)) + 1)
            .toString()
            .padLeft(3, '0'); // Increment and pad with zeros
        print("Max ID: $newId");
        _id = "Ms${newId}";
        setState(() {
          enable_add = true;
        });
      } else {
        // Handle non-200 status codes
        setState(() {
          enable_add = false;
        });
      }
    } catch (error) {
      // Catch and handle errors like network issues
      setState(() {
        enable_add = false;
      });
    }
  }

  // ฟังก์ชันเลือกภาพ
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveSong() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create new Song object
      Song newSong = Song(
          id: _id,
          songTitle: _title,
          artistName: _artist,
          album: _album,
          genre: _genre,
          image: _urlImg);

      print(newSong.id);

      // Use the centralized saveSong function
      try {
        await createSong(newSong);
        Navigator.pop(context, true); // Return true to indicate successful save
      } catch (e) {
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save song: $e')),
        );
      }
    }
  }

  // ฟังก์ชันสำหรับอัปเดตไฟล์ JSON
  Future<void> _updateJsonFile(Song song) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    print(file);
    if (await file.exists()) {
      // อ่านข้อมูลเก่าจากไฟล์
      final content = await file.readAsString();
      List<dynamic> data = json.decode(content)['songs'];

      // เพิ่มเพลงใหม่เข้าไปในรายการ
      data.add(song.toJson());

      // เขียนข้อมูลใหม่ลงในไฟล์
      await file.writeAsString(json.encode({'songs': data}));
    } else {
      // สร้างไฟล์และเขียนเพลงแรกลงไป
      await file.writeAsString(json.encode({
        'songs': [song.toJson()]
      }));
    }
  }

  void _getImg(String value) {
    // print(value);
    setState(() {
      imgShow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Song'),
        backgroundColor: Color(0xffe9a7b2),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image Upload Section
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Image.network(
                    imgShow,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Return an empty container or a placeholder image to ignore the error
                      return Image.asset(
                        "assets/noimg.jpg", // Update with the correct path to your asset image
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                enable_add
                    ? Container()
                    : Text(
                        "ไม่สามารถเพิ่มข้อมูลได้ ณ ขณะนี้ กรุณาลองใหม่อีกครั้ง!",
                        style: TextStyle(color: Colors.red, fontSize: 18.00),
                      ),
                SizedBox(height: 20),

                // Song Title Field
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Song Title',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _title = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a song title';
                      }
                      return null;
                    },
                    enabled: enable_add),
                SizedBox(height: 16),

                // Artist Name Field
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Artist Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _artist = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an artist name';
                      }
                      return null;
                    },
                    enabled: enable_add),
                SizedBox(height: 16),

                // Album Field
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Album',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _album = value!,
                    enabled: enable_add),
                SizedBox(height: 16),

                // Genre Field
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Genre',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _genre = value!,
                    enabled: enable_add),
                SizedBox(height: 20),

                // Genre Field
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Image Link',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _urlImg = value!,
                    onChanged: (value) => {_getImg(value)},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a song title';
                      }
                      return null;
                    },
                    enabled: enable_add),
                SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: enable_add
                      ? _saveSong
                      : null, // เรียกใช้ฟังก์ชันบันทึกข้อมูลเพลง
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffe9a7b2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
