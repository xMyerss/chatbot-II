import 'package:flutter/material.dart';
import 'home_screen.dart';  // Importa la pantalla Home
import 'chat_screen.dart';  // Importa la pantalla Chat

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universidad ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
