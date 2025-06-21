
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authservice.dart';


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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    void registerUser() async {
      try{
        if (_nameController.text.isEmpty ||
            _usernameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please fill all fields.')),
          );
          return;
        }

        if(!mounted) return;
        if (_usernameController.text.length < 4) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Invalid username'),
              content: Text('Username must be at least 4 characters long'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () =>Navigator.of(context).pop(),
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

          if(!mounted) return;
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
        }else{
          final error = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error['message'] ?? 'Something went wrong'}')),
          );
        }
      }catch(e){
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }


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
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
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
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                CustomButton(text: 'Register', onPressed: registerUser,),

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
                          text: 'Already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Cash Light',
                          ),
                          children: [
                            TextSpan(
                              text: 'Log in',
                              style: TextStyle(
                                color: AppColors.highlight,
                                fontWeight: FontWeight.bold,
                                decoration:TextDecoration.underline,
                                decorationColor: AppColors.highlight,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  Navigator.pushNamed(context, '/login');
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
            /*Container(
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
                ),*/


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
