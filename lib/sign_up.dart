import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authservice.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void registerUser() async {
    try {
      if (_nameController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields.')),
        );
        return;
      }

      if (!mounted) return;
      if (_usernameController.text.length < 4) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Invalid username'),
            content: Text('Username must be at least 4 characters long'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      }

      final url = Uri.parse('https://c266-102-68-79-99.ngrok-free.app/api/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'name': _nameController.text,
          'role': 'user'
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final user = responseData['user'];

        await AuthService.saveToken(token);
        await AuthService.saveUser(user);

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Check your email to verify your account before logging in.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
            ],
          ),
        );
        return;
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error['message'] ?? 'Something went wrong'}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/signup.jpeg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: colorScheme.background.withOpacity(0.1),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.1),
                Text(
                  'Sign Up',
                  style: textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontFamily: 'Groovetastic',
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Register',
                  onPressed: registerUser,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 2,
                      width: 60,
                      color: colorScheme.onPrimary,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Already have an account?',
                        style: GoogleFonts.roboto().copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight:FontWeight.bold,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: ' Log in',
                            style: GoogleFonts.roboto().copyWith(
                              color: colorScheme.primary,
                              fontWeight:FontWeight.bold,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),

                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/login');
                              },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 60,
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: TopBar(
              onBackPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
