import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:twitter_login/twitter_login.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method untuk melakukan registrasi pengguna baru dengan email dan password
  Future<User?> signUp(String firstName, String lastName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Method untuk melakukan login pengguna dengan email dan password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Method untuk keluar dari sesi pengguna
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  // Method untuk mengambil informasi pengguna dari Firestore
  Future<DocumentSnapshot> getUserInfo(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  // Google Sign-In
  // Future<UserCredential?> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   if (googleUser != null) {
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   }
  //   return null;
  // }

  // Facebook Sign-In
  // Future<UserCredential?> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   if (loginResult.accessToken != null) {
  //     // Create a credential from the access token
  //     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //     // Once signed in, return the UserCredential
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   }
  //   return null;
  // }

  // Twitter Sign-In
  // Future<UserCredential?> signInWithTwitter() async {
  //   // Create a TwitterLogin instance
  //   final twitterLogin = TwitterLogin(
  //     apiKey: '<your consumer key>',
  //     apiSecretKey: '<your consumer secret>',
  //     redirectURI: '<your_scheme>://',
  //   );
  //
  //   // Trigger the sign-in flow
  //   final authResult = await twitterLogin.login();
  //
  //   if (authResult.authToken != null && authResult.authTokenSecret != null) {
  //     // Create a credential from the access token
  //     final twitterAuthCredential = TwitterAuthProvider.credential(
  //       accessToken: authResult.authToken!,
  //       secret: authResult.authTokenSecret!,
  //     );
  //
  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  //   }
  //   return null;
  // }
}
