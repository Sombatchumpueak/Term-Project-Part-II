import 'package:flutter/material.dart';
import 'models/song.dart';
import 'api_service.dart'; // Import the api_service for save functionality

class EditSongPage extends StatefulWidget {
  @override
  _EditSongPageState createState() => _EditSongPageState();
}

class _EditSongPageState extends State<EditSongPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _artist;
  late String _album;
  late String _genre;
  late String _id; // Store the song ID
  late String _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch the song object passed as argument
    final Song song = ModalRoute.of(context)!.settings.arguments as Song;

    // Initialize the form fields with song data
    _title = song.songTitle;
    _artist = song.artistName;
    _album = song.album;
    _genre = song.genre;
    _id = song.id;
    _image = song.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Song'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Song Title'),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a song title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _artist,
                decoration: InputDecoration(labelText: 'Artist Name'),
                onSaved: (value) => _artist = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an artist name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _album,
                decoration: InputDecoration(labelText: 'Album'),
                onSaved: (value) => _album = value!,
              ),
              TextFormField(
                initialValue: _genre,
                decoration: InputDecoration(labelText: 'Genre'),
                onSaved: (value) => _genre = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create updated song object
                    Song updatedSong = Song(
                      id: _id,
                      songTitle: _title,
                      artistName: _artist,
                      album: _album,
                      genre: _genre,
                      image: _image, // Assuming image is not updated here
                    );

                    // Save the updated song
                    saveSong(updatedSong).then((_) {
                      // Navigate back after saving
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (Route<dynamic> route) => false);
                    }).catchError((error) {
                      // Handle error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save song: $error')),
                      );
                    });
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
