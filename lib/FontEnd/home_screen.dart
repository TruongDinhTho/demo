import 'package:demo/FontEnd/AuthUI/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: Text('Log out'),
        ),
      ),
    );
  }
}
