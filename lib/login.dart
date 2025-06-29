import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  void dispose(){
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final url = Uri.parse('https://b78d-102-68-79-99.ngrok-free.app /api/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final user = data['user'];

        await storage.write(key: 'authToken', value: token);
        await storage.write(key: 'userData', value: jsonEncode(user));

        if(!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Login Successful'),
            content: Text('Login successful, click ok to continue!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () =>Navigator.pushReplacementNamed(context, '/home'),
              ),
            ],
          ),
        );
        return;

      }else if(response.statusCode == 403){
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Email Not Verified"),
            content: Text('Please verify your email!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }else {
        if(!mounted){return;}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login.jpeg',
            fit: BoxFit.cover,
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent.withValues(alpha:0),
            ),

          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.1),
                Text(
                  'Log In',
                  style: GoogleFonts.roboto(
                    color: colorScheme.onPrimary,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Username',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(text: 'Login', onPressed: loginUser,),
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
                        text: "Don't have an account?",
                        style: GoogleFonts.roboto().copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight:FontWeight.bold,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: GoogleFonts.roboto().copyWith(
                              color: colorScheme.primary,
                              fontWeight:FontWeight.bold,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),

                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/signUp');
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
                const SizedBox(height: 40,),
               /* Container(
                  width: double.infinity,
                  height: height * 0.06,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Image.asset('assets/images/google.png'),
                          SizedBox(width: width*0.105,),
                          Text(
                            "Continue with Google",
                            style: const TextStyle(
                              fontFamily: 'Cash Light',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                  ),
                ),*/
                SizedBox(height: 20,),

               /* Container(
                  width: double.infinity,
                  height: height * 0.06,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Image.asset('assets/images/apple.png'),
                          SizedBox(width: width * 0.1,),
                          Text(
                            "Continue with Apple",
                            style: const TextStyle(
                              fontFamily: 'Cash Light',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                  ),
                ),*/


              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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
