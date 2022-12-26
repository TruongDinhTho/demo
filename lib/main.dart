import 'package:demo/FontEnd/AuthUI/login.dart';
import 'package:demo/FontEnd/AuthUI/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      title: 'App Chat',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: LoginScreen(),
    )
  );
}

