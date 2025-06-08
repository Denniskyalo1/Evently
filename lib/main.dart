
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'selected_event.dart';
import 'sign_up.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/signUp': (context) => const SignUp(),
        '/login': (context) => const Login(),

      },
    );
  }
}

