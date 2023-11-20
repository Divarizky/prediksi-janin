import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:janin/view/home/navbar.dart';
import 'package:janin/view/signin/signin.dart';
import 'package:janin/view/signin/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String id = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> streamAuthStatus() {
    return auth.authStateChanges();
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Create an instance of google signin
    final GoogleSignIn googleSignIn = GoogleSignIn();
    //Triger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    //Create a new credentials
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //Sign in the user with the credentials
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    return null;
  }

  void SignInProvider(String email, String password, context) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      id = user.user!.uid;
      pageRoute(id);
      print(id);
      // final result = await prefs.getString("uid");
      // print('hasil: $result');

      // final SharedPreferences prefs = await _prefs;
      // await prefs.setString("uid",id);
      // print("jalan");
      if (user.user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbar(),
          ),
        );
      } else {
        showTextMessage(context, "Anda Perlu Verifikasi Email Terlebih Dahulu");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showTextMessage(context, 'Email tidak ditemukan');
      } else if (e.code == 'wrong-password') {
        showTextMessage(context, 'Kata sandi yang anda masukan salah');
      }
    }
    notifyListeners();
  }

  void SignUpProvider(
      String email, String password, String nama, String no, context) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await user.user!.sendEmailVerification();
      showTextMessage(
          context, 'Mohon cek email anda \n \v Akun berhasil dibuat');
      postDetailsToFirestore(id,email, nama, no, context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showTextMessage(context, 'Kata sandi terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        showTextMessage(context, 'Akun berikut sudah terdaftar');
      }
    } catch (e) {
      return;
    }
  }

  void resetPassword(String _emailController, context) async {
    try {
      await auth.sendPasswordResetEmail(email: _emailController);
      showTextMessage(context, "Mohon Cek Email Anda");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
    } catch (e) {
      return;
    }
  }

  void logOut(context) async {
    await auth.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignIn(),
      ),
    );
    notifyListeners();
  }

  postDetailsToFirestore(String id, String email, String nama, String no, context) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final userData = <String, dynamic>{
      "id":user!.uid,
      "namaController": nama,
      "emailController": email,
      "noController": no,
    };
    db.collection("users").doc(user.uid).set(userData);
  }

  updateDetailsToFirestore(
      String email, String nama, String no, String image, context) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final userData = <String, dynamic>{
      "namaController": nama,
      "emailController": email,
      "noController": no,
      "image": image,
    };
    db.collection("users").doc(user!.uid).update(userData);
    showTextMessage(context, 'Akun berhasil diupdate');
  }

  void pageRoute(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("uid", id);
  }
}
