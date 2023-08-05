import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connections_tutorials/UI/auth/verify_code.dart';
import 'package:firebase_connections_tutorials/Utils/Utils.dart';
import 'package:firebase_connections_tutorials/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';


class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();

  final countryPicker = const FlCountryCodePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('login'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            TextFormField(
              maxLines: 1,
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "+91 9890182987"
              ),
            ),
            const SizedBox(height: 80),
            RoundButton(title: 'Send verification code ',loading: loading, onTap: (){
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                  setState(() {
                    loading = false;
                  });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                  Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId,)));
                  },
                  codeAutoRetrievalTimeout: (e){
                    Utils().toastMessage(e.toString());
                    setState(() {
                    loading = false;
                    });
                });

            }),

          ],
        ),
      ),

    );
  }
}
