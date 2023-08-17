import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connections_tutorials/UI/auth/login_screen.dart';
import 'package:firebase_connections_tutorials/Utils/Utils.dart';
import 'package:firebase_connections_tutorials/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        setState(() {
          loading = false;
        });
      });
    });
  }

  void _onSignUpButtonPressed(BuildContext context) {
    // Simulating a successful sign-up
    bool isSignUpSuccessful = true;
    if (isSignUpSuccessful) {
      // Navigate to the HomeScreen after successful sign-up
      Fluttertoast.showToast(
        msg: "Sign-up successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Center(child: Text('Sign up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 5),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/vecteezy_3d-face-lock-illustration_12421891_249.png'),
                radius: 120,
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,letterSpacing: 3,fontSize: 15),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',hintStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,letterSpacing: 3,fontSize: 15),
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ))),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Sign up',
              loading: loading,
              onTap: () {
                _onSignUpButtonPressed(context);
                if (_formKey.currentState!.validate()) {
                  signUp();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}