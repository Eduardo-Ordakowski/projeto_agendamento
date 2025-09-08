import 'package:flutter/material.dart';
import 'package:projeto_agendamento/login_screen.dart';
import 'package:projeto_agendamento/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Agendamento',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Palette.backgroundColor,
      ),
      home: LoginScreen(),
    );
  }
}
