import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connections_tutorials/UI/auth/login_with_phone_number.dart';
import 'package:firebase_connections_tutorials/UI/auth/posts/post_screen.dart';
import 'package:firebase_connections_tutorials/UI/auth/signup_screen.dart';
import 'package:firebase_connections_tutorials/Utils/Utils.dart';
import 'package:firebase_connections_tutorials/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Center(child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 5),)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/vecteezy_3d-password-input-illustration-design_10998284_874.png'),
                      radius: 120,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: const InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(Icons.email_outlined),

                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,letterSpacing: 3,fontSize: 15)
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Password', hintStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,letterSpacing: 3,fontSize: 15),
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
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign up'))
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginWithPhoneNumber()));
                },
                child: Container(
                  width: 500,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red,

                      )
                  ),
                  child: const Center(
                    child: Text('Login with Phone Number..', style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 3,fontSize: 15),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}