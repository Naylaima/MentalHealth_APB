import 'package:flutter/material.dart';

class JournalHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Search your journal',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _yearCard('2023', Colors.pink),
                  _yearCard('2022', Colors.blue),
                  _yearCard('2021', Colors.purple),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _journalEntry('Februari 26', Colors.pink),
                  _journalEntry('Juni 7', Colors.blue),
                  _journalEntry('September 1', Colors.purple),
                  _journalEntry('April 27', Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your add journal functionality here
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
        ],
        currentIndex: 2, // Set the current index to 'Journal'
      ),
    );
  }

  Widget _yearCard(String year, Color color) {
    return Card(
      color: color,
      child: Container(
        width: 100,
        height: 150,
        child: Center(
          child: Text(
            year,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget _journalEntry(String date, Color color) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 10,
          height: 60,
          color: color,
        ),
        title: Text(date),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Implement your journal entry tap functionality here
        },
      ),
    );
  }
}
