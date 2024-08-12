import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
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
        title: Row(
          children: [
            Image.asset(
              'images/Butterfly.png', // Path ke gambar Anda
              height: 30, // Tinggi gambar
            ),
            SizedBox(width: 10), // Spasi antara gambar dan teks
            Text(
              'Berita Kesehatan',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),

      body: NewsList(),
    );
  }
}

class NewsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Berita').orderBy('publishedDate', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No news available'));
        }

        final newsDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: newsDocs.length,
          itemBuilder: (context, index) {
            final newsData = newsDocs[index].data() as Map<String, dynamic>;
            final title = newsData['title'] ?? 'No Title';
            final content = newsData['content'] ?? 'No Content';
            final author = newsData['author'] ?? 'Unknown';
            final publishedDate = newsData['publishedDate']?.toDate() ?? DateTime.now();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('By $author on ${publishedDate.toLocal().toString().split(' ')[0]}'),
                      SizedBox(height: 5),
                      Text(
                        content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(newsData: newsData),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsData;

  NewsDetailScreen({required this.newsData});

  @override
  Widget build(BuildContext context) {
    final title = newsData['title'] ?? 'No Title';
    final content = newsData['content'] ?? 'No Content';
    final author = newsData['author'] ?? 'Unknown';
    final publishedDate = newsData['publishedDate']?.toDate() ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('By $author on ${publishedDate.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 16),
            Text(content),
          ],
        ),
      ),
    );
  }
}
