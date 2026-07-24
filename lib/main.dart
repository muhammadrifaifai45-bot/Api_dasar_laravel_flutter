import 'package:flutter/material.dart';
import 'layar/LoginxiezPage.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CRUD LARAVEL FLUTTER",
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blueGrey,
    ),
    home: const LoginPage(),
   );
  }
}