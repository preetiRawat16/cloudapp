import 'package:cloudchat/search.dart';
import 'package:cloudchat/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'genshin_main.dart';
import 'signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Google Sign-Up',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const userprofile(),
    );
  }
}
