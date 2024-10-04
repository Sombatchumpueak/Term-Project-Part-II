import 'dart:convert';
import 'package:flutter/services.dart'; // For loading assets
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_application_2/config_data.dart';
import 'dart:io'; // For File
import 'package:path_provider/path_provider.dart'; // For accessing directories
import 'models/song.dart';
import 'package:http/http.dart' as http;

// Function to fetch songs from JSON file
Future<List<Song>> fetchSongs() async {
  try {
    final url = Uri.parse('${data_config}/songs');
    final response = await http.get(
      url, // ใช้คำสั่ง get แทน
    );
    // print('url:${response.body}');
    // final String response = await rootBundle.loadString('assets/data.json');
    final data = json.decode(response.body);
    // print('data${data}');

    List<Song> songs = [];

    for (var d in data) {
      songs.add(Song(
          id: d['id'],
          songTitle: d['songTitle'],
          artistName: d['artistName'],
          album: d['album'],
          genre: d['genre'],
          image: d['image']));
    }

    print(songs);

    // Convert each song in List to Song objects
    // List<Song> songs =
    //     (data).map((songData) => Song.fromJson(songData)).toList();

    return songs; // Return list of songs
  } catch (e) {
    print("Failed to fetch songs: $e");
    throw Exception('Could not fetch songs');
  }
}

Future<void> createSong(Song song) async {
  print('hihihihi:${song.id}, ${song.image}, ${song.album}');

  final url = Uri.parse('${data_config}/songs');
  var data = {
    'id': song.id,
    'songTitle': song.songTitle,
    'artistName': song.artistName,
    'album': song.album,
    'genre': song.genre,
    'image': song.image
  };

  try {
    // Sending the Post request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    // Checking for success or failure
    if (response.statusCode == 201) {
      print('Song create successfully!');
    } else {
      print('Failed to create song. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    // Catching and handling any errors
    print('An error occurred: $error');
  }
}

// Function to save a song to the JSON file
Future<void> saveSong(Song song) async {
  print('hihihihi:${song.id}, ${song.image}');

  final url = Uri.parse('${data_config}/songs/${song.id}');
  var data = {
    'id': song.id,
    'songTitle': song.songTitle,
    'artistName': song.artistName,
    'album': song.album,
    'genre': song.genre,
    'image': song.image
  };

  try {
    // Sending the PUT request
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Checking for success or failure
    if (response.statusCode == 200) {
      print('Song updated successfully!');
    } else {
      print('Failed to update song. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    // Catching and handling any errors
    print('An error occurred: $error');
  }
}

// Function to save a song to the JSON file
Future<bool> delSong(String id) async {
  final url = Uri.parse('${data_config}/songs/${id}');

  try {
    // Sending the PUT request
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // Checking for success or failure
    if (response.statusCode == 200) {
      print('Song del successfully!');
      return true;
    } else {
      print('Failed to del song. Status Code: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    // Catching and handling any errors
    print('An error occurred: $error');
    return false;
  }
}
