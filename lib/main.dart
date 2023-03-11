
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screen/crudlophoc.dart';
import 'Screen/splashcardscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD DEMO',
      home: CardApp(),
      routes: {
        crudlophoc.routeName: (ctx) =>crudlophoc(),
        CardApp.routeName: (ctx) =>CardApp(),
      },
    );
  }
}
