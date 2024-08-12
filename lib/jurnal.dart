import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class JurnalPage extends StatefulWidget {
  @override
  _JurnalPageState createState() => _JurnalPageState();
}

class _JurnalPageState extends State<JurnalPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController _journalTitleController = TextEditingController();
  TextEditingController _journalContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double calendarHeight = screenHeight * 0.5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Jurnal Harian', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: calendarHeight,
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.red),
                weekdayStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Text(
                      'MY JOURNAL',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('journals')
                          .where('date', isEqualTo: _selectedDay)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.data?.docs.isEmpty ?? true) {
                          return Center(child: Text('Tidak ada jurnal untuk tanggal ini.'));
                        }
                        return ListView(
                          children: snapshot.data!.docs.map((doc) {
                            return _buildEventTile(doc['title'], doc['content'], screenWidth);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddJournalDialog(context);
        },
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildEventTile(String title, String content, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      child: Card(
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.black)),
          subtitle: Text(content, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  void _showAddJournalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Memberikan jarak horizontal
          child: AlertDialog(
            title: Text("Tambah Jurnal"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _journalTitleController,
                    decoration: InputDecoration(labelText: 'Judul'),
                  ),
                  TextField(
                    controller: _journalContentController,
                    decoration: InputDecoration(labelText: 'Isi Jurnal'),
                    maxLines: null, // Membuat TextField bisa multi-line
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
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
                  _addJournal();
                  Navigator.pop(context);
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addJournal() {
    FirebaseFirestore.instance.collection('journals').add({
      'title': _journalTitleController.text,
      'content': _journalContentController.text,
      'date': _selectedDay,
    }).then((value) {
      // Jurnal berhasil ditambahkan
      _journalTitleController.clear();
      _journalContentController.clear();
    }).catchError((error) {
      // Gagal menambahkan jurnal
      print("Gagal menambahkan jurnal: $error");
    });
  }
}
