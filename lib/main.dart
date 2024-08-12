import 'package:apb_mentaly/test_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'SignIn.dart';
import 'login.dart';
import 'homePage.dart';
import 'profile.dart';
//import 'jurnalHome.dart';
import 'forum.dart';
import 'rekomendasiDokter.dart';
import 'jurnal.dart';
import 'beritaKesehatan.dart';
import 'chatDokter.dart';
//import 'berita.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {

  final String? email;
  MyApp({this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const TestFirestore(),
      initialRoute: email == null ? '/signup' : '/home',
      routes: {
        //'/': (context) => LoginPage(),
        '/signup': (context) => SignInScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profil': (context) => ProfileScreen(),
        //'/journal': (context) => JournalHomePage(),
        '/forum': (context) => ForumPage(),
        '/chat': (context) => RekomendasiDokter(),
        '/jurnal': (context) => JurnalPage(),
        '/berita' : (context) => NewsScreen(),
        '/signin' : (context) => SignInScreen(),
        '/chatDokter': (context) => ChatPage(doctor: {},),
      },
    );
  }
}
