import 'package:flutter/material.dart';
import 'package:weatherapp/Screens/homescreen.dart';

void main() {
  runApp(const Myapp2());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScrn();
  }
}

class Myapp2 extends StatelessWidget {
  const Myapp2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Myapp(), debugShowCheckedModeBanner: false,);
  }
}
