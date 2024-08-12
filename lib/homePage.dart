import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_controller.dart'; // Import the auth_controller
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Color _selectedFeelingColor = Colors.transparent;
  User? _currentUser;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    if (_currentUser != null) {
      DocumentSnapshot userInfo = await AuthController().getUserInfo(_currentUser!.uid);
      setState(() {
        _userInfo = userInfo.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  'images/Butterfly.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10), // Menambahkan jarak antara gambar dan teks
                Expanded(
                  child: Text(
                    'Hi, ${_userInfo?['firstName'] ?? 'Guest'} ${_userInfo?['lastName'] ?? ''}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'How do you feel?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _feelingButton('disgust', Icons.sentiment_dissatisfied, Colors.greenAccent),
                _feelingButton('fear', Icons.sentiment_very_dissatisfied, Colors.purpleAccent),
                _feelingButton('joy', Icons.sentiment_satisfied, Colors.yellowAccent),
                _feelingButton('sadness', Icons.sentiment_dissatisfied, Colors.blueAccent),
                _feelingButton('anger', Icons.sentiment_very_dissatisfied, Colors.red),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  _menuButton(context, 'Jurnal harian', Icons.person, '/jurnal'),
                  _menuButton(context, 'Forum diskusi', Icons.forum, '/forum'),
                  _menuButton(context, 'Berita kesehatan', Icons.article, '/berita'),
                  _menuButton(context, 'Chat psikolog', Icons.chat, '/chat'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _feelingButton(String label, IconData icon, Color color) {
    return Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: _selectedFeelingColor == color ? color : Colors.transparent,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, size: 40),
            color: Colors.grey, // Warna ikon
            onPressed: () {
              // Aksi saat ikon ditekan
              setState(() {
                // Mengubah warna ikon setelah diklik
                _selectedFeelingColor = color;
              });
            },
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _menuButton(BuildContext context, String label, IconData icon, String route) {
    return Card(
      color: Colors.yellow,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 50),
              SizedBox(height: 10),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/profil');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
