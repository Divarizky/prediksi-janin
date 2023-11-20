import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/provider/iconkatasandi.dart';
import 'package:janin/provider/navbarprovider.dart';
import 'package:janin/provider/prediksi.dart';
import 'package:janin/view/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => IconKataSandi(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavbarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PrediksiProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
