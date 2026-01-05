import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? name;
  String? email;
  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final token = await storage.read(key: 'authToken');
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);


        final data = decoded['data'] ?? decoded;

        setState(() {
          name = data['name'];
          email = data['email'];
          username = data['username'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Failed to load profile: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          color: colorScheme.onSurface,
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
        title: Text(
          'My Profile',
          style: GoogleFonts.roboto(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        elevation: 30.0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.primary,
              child: Text(
                name != null && name!.isNotEmpty
                    ? name![0].toUpperCase()
                    : '',
                style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildProfileField('Name', name ?? 'N/A', colorScheme),
            buildProfileField('Email', email ?? 'N/A', colorScheme),
            buildProfileField('Username', username ?? 'N/A', colorScheme),
            const SizedBox(height: 30),

            CustomButton(
              text: 'My tickets',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/mytickets');

              },
            ),
            SizedBox(height: 20,),

            RichText(
              text: TextSpan(
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                children: [
                  const TextSpan(text: 'Want to add an event to our app? Do so easily through '),
                  TextSpan(
                    text: 'here.',
                    style: GoogleFonts.roboto(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/submitevent');
                      },
                  ),
                ],
              ),
            ),

            SizedBox(height: 200,),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                    text: 'Log Out',
                    onPressed: () async {
                      await storage.delete(key: 'authToken');
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                  ),
                ),
              ],
        ),
      ),
    );
  }

  Widget buildProfileField(String label, String value, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
          ),
        ),
        const Divider(height: 30),
      ],
    );
  }
}
