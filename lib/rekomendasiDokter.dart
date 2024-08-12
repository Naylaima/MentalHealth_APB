import 'package:flutter/material.dart';
import 'chatDokter.dart';

class RekomendasiDokter extends StatefulWidget {
  @override
  _RekomendasiDokterState createState() => _RekomendasiDokterState();
}

class _RekomendasiDokterState extends State<RekomendasiDokter> {
  final List<Map<String, dynamic>> allDoctors = [
    {
      'name': 'dr. Vadilla, Sp.KJ',
      'experience': '5 tahun',
      'rating': '98%',
      'image': 'assets/doctor1.png' // Replace with your asset path
    },
    {
      'name': 'dr. Evans, Sp.KJ',
      'experience': '12 tahun',
      'rating': '100%',
      'image': 'assets/doctor2.png' // Replace with your asset path
    },
    {
      'name': 'dr. Namor, Sp.KJ',
      'experience': '8 tahun',
      'rating': '95%',
      'image': 'assets/doctor3.png' // Replace with your asset path
    },
    {
      'name': 'dr. Jaems, Sp.KJ',
      'experience': '6 tahun',
      'rating': '92%',
      'image': 'assets/doctor4.png' // Replace with your asset path
    },
    {
      'name': 'dr. Nay, Sp.KJ',
      'experience': '10 tahun',
      'rating': '97%',
      'image': 'assets/doctor5.png' // Replace with your asset path
    },
  ];

  List<Map<String, dynamic>> filteredDoctors = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDoctors = allDoctors;
  }

  void searchDoctor(String query) {
    setState(() {
      filteredDoctors = allDoctors
          .where((doctor) => doctor['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5DC),
        title: Text('Rekomendasi Dokter'),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset(
                  'images/Butterfly.png',
                  width: 50,
                  height: 50,
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by doctor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10), // Spacer
                ElevatedButton(
                  onPressed: () {
                    searchDoctor(searchController.text);
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(filteredDoctors[index]['image']),
                    ),
                    title: Text(filteredDoctors[index]['name']),
                    subtitle: Row(
                      children: [
                        Text(filteredDoctors[index]['experience']),
                        SizedBox(width: 8),
                        Text(filteredDoctors[index]['rating']),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(doctor: filteredDoctors[index]),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow, // Warna latar belakang tombol
                          foregroundColor: Colors.deepPurple, // Warna teks tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Membuat sudut tombol melengkung
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12), // Padding dalam tombol
                        ),
                        child: Text('Chat'),
                      ),
                    ),

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: RekomendasiDokter()));
