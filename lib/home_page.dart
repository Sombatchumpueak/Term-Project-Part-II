import 'package:flutter/material.dart';
import 'package:flutter_application_2/add_song_page.dart';
import 'package:flutter_application_2/config_data.dart';
import 'package:flutter_application_2/music_page.dart';
import 'package:flutter_application_2/song_detail_page.dart';
import 'models/song.dart'; // Import for Song model
import 'api_service.dart'; // Import for fetching songs
import 'alert_message.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Set initial index for the bottom navigation
  Song? _selectedSong; // State for selected song
  List<Song> _songs = []; // State for storing the list of songs

  @override
  void initState() {
    super.initState();
    _loadSongs(); // Load the songs when the page initializes
    print('too long');
  }

  Future<void> _loadSongs() async {
    final songs =
        await fetchSongs(); // Fetch the songs from the API or local storage
    setState(() {
      _songs = songs; // Update the song list state
    });
  }

  // Handle song selection
  void _onSongSelected(Song song) {
    setState(() {
      _selectedSong = song; // Save selected song
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SongDetailPage(song: song), // Navigate to SongDetailPage
      ),
    );
  }

  // Handle bottom tab tap event
  void _onTabTapped(int index) async {
    setState(() {
      _currentIndex = index; // Update current tab index
    });

    if (_currentIndex == 2) {
      // Navigate to AddSongPage if Add tab is selected
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSongPage(), // Navigate to AddSongPage
        ),
      );

      // Check if a song was added, refresh the song list
      if (result == true) {
        _loadSongs(); // Refresh the song list after adding a new song
      }
    } else if (_currentIndex == 1) {
      // Navigate to MusicPage with selected song when Music tab is selected
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MusicPage(
            selectedSong: _selectedSong, // Pass the selected song to MusicPage
          ),
        ),
      );
    }
  }

  // Update song in the list when edited
  void _updateSong(Song updatedSong) {
    setState(() {
      final index = _songs.indexWhere((song) => song.id == updatedSong.id);
      if (index != -1) {
        _songs[index] = updatedSong;
      }
    });
  }

  // Function to delete a song
  Future<void> _deleteSong(Song song) async {
    bool del_confirm = await delSong(song.id);
    if (del_confirm) {
      showDeleteSuccessAlert(context);
    } else {
      // show dialog that is an error
      showDeleteErrorAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xffe9a7b2),
        elevation: 0,
      ),
      // Add gradient background to HomePage
      body: Stack(
        children: [
          // Gradient background container
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE9A7B2), // Top gradient color
                  Colors.white, // Bottom gradient color
                ],
              ),
            ),
          ),
          // Content of HomePage
          _songs.isEmpty
              ? Center(
                  child: CircularProgressIndicator()) // Show loading spinner
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildImageCard('assets/loves.jpg', 'Lover'),
                            _buildImageCard('assets/Pink.jpg', 'At My Worst'),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _songs.length,
                        itemBuilder: (context, index) {
                          return _buildSongItem(context, _songs[index]);
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
      // Add BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Call _onTabTapped on tap
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
      ),
    );
  }

  Future<bool> imageExists(String imagePath) async {
    try {
      await rootBundle.load(imagePath);
      return true; // Image exists
    } catch (e) {
      return false; // Image does not exist
    }
  }

  void checkImage(String img) async {
    bool exists = await imageExists('assets/${img}');
    if (exists) {
      print('Image exists!');
    } else {
      print('Image does not exist.');
    }
  }

  // Function to display song item with a delete button
  Widget _buildSongItem(BuildContext context, Song song) {
    String img = song.image;

    return ListTile(
      title: Text(song.songTitle),
      subtitle: Text(song.artistName),
      leading: Image.network(
        img,
        height: 200,
        width: 50,
        // fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/noimg.jpg", // Update with the correct path to your asset image
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_sharp, color: Colors.black45), // Delete button
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Delete'),
                content: Text('Are you sure you want to delete this item?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Call your delete function here

                      Navigator.of(context).pop(); // Close the dialog
                      _deleteSong(song); // Call function to delete song
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );
        },
      ),
      onTap: () {
        _onSongSelected(song); // Call function when song is tapped
      },
    );
  }

  // Function to display image and song card
  Widget _buildImageCard(String imagePath, String title) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
