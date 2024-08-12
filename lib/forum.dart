import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Map<String, dynamic>> _posts = [];
  TextEditingController _postContentController = TextEditingController();
  Map<String, dynamic>? _userInfo = {};


  @override
  void initState() {
    super.initState();
    _fetchPosts();
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Forum Diskusi',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/Butterfly.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return _forumPost(_posts[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
    );
  }

  Widget _forumPost(Map<String, dynamic> post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_formatTime(post['time'])),
            SizedBox(height: 10),
            Text(post['content']),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        _likePost(post);
                      },
                    ),
                    SizedBox(width: 5),
                    Text('${post['likes']} Orang'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        _showAddCommentDialog(context, post);
                      },
                    ),
                    SizedBox(width: 5),
                    Text('${post['comments']} Komentar'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    DateTime postTime = DateTime.parse(time);
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }


  void _showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unggah Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _postContentController,
                decoration: InputDecoration(labelText: 'Konten Post'),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _uploadPost();
                Navigator.pop(context);
              },
              child: Text('Unggah'),
            ),
          ],
        );
      },
    );
  }

  void _uploadPost() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('posts').add({
        'name': user.displayName ?? (_userInfo != null ? '${_userInfo!['firstName']} ${_userInfo!['lastName']}' : 'Unknown User'),
        'content': _postContentController.text,
        'time': DateTime.now().toIso8601String(),
        'likes': 0,
        'comments': 0,
      }).then((value) {
        // Jika post berhasil diunggah, tambahkan post ke _posts list
        setState(() {
          _posts.add({
            'name': user.displayName ?? (_userInfo != null ? '${_userInfo!['firstName']} ${_userInfo!['lastName']}' : 'Unknown User'),
            'content': _postContentController.text,
            'time': DateTime.now().toIso8601String(),
            'likes': 0,
            'comments': 0,
          });
        });
      }).catchError((error) {
        print("Gagal mengunggah post: $error");
      });
    } else {
      print('Error: User is not signed in.');
    }
  }


  void _fetchPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> post = {
          'name': doc['name'],
          'content': doc['content'],
          'time': doc['time'],
          'likes': doc['likes'],
          'comments': doc['comments'],
        };
        setState(() {
          _posts.add(post);
        });
      });
    }).catchError((error) {
      print("Gagal mengambil post: $error");
    });
  }

  void _showAddCommentDialog(BuildContext context, Map<String, dynamic> post) {
    // Implementasi dialog untuk menambahkan komentar ke post tertentu
  }

  void _likePost(Map<String, dynamic> post) {
    setState(() {
      post['likes']++;
    });
  }
}
