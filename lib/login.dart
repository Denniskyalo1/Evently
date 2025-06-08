import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
              color: Colors.transparent.withOpacity(0),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Groovetastic',
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(text: 'Login', onPressed: (){},),
                const SizedBox(height: 24),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 2,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Don't have an account?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Cash Light',
                            ),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: AppColors.highlight,
                                  fontWeight: FontWeight.bold,
                                  decoration:TextDecoration.underline,
                                  decorationColor: AppColors.highlight,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    Navigator.pushNamed(context, '/signUp');
                                  },
                              ),
                            ]
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ]
                ),
                const SizedBox(height: 40,),
                Container(
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
                ),
                SizedBox(height: 20,),

                Container(
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
                ),


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
