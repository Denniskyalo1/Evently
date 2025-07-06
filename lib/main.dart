import 'package:event_management/adminprofile.dart';
import 'package:event_management/mytickets.dart';
import 'package:event_management/profile.dart';
import 'package:event_management/submitevent.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'sign_up.dart';
import 'login.dart';
import 'eventrequests.dart';

void main() {
  runApp(MyApp());
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.green,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    outline: Colors.black,
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
    outline: Colors.white,
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(toggleTheme: toggleTheme),
      routes: {
        '/home': (context) => HomeScreen(toggleTheme: toggleTheme),
        '/signUp': (context) => const SignUp(),
        '/login': (context) => const Login(),
        '/profile': (context) => const ProfilePage(),
        '/adminprofile': (context) => const AdminProfile(),
        '/mytickets': (context) => const MyTicketsPage(),
        '/submitevent' : (context) => const SubmitEventPage(),
        '/eventrequests' : (context) => const EventRequestsPage(),
      },
    );
  }
}
