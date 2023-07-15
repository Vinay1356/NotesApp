import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connections_tutorials/UI/auth/posts/post_screen.dart';
import 'package:firebase_connections_tutorials/Utils/Utils.dart';
import 'package:flutter/material.dart';
import '../../widgets/round_button.dart';


class VerifyCodeScreen extends StatefulWidget {

  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {

  bool loading = false;
  final auth = FirebaseAuth.instance;
  final verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            TextFormField(
              controller: verificationCodeController,
              decoration: const InputDecoration(
                  hintText: '0 0 0 0 0 0'
              ),
            ),
            const SizedBox(height: 80),
            RoundButton(title: 'Verify',loading: loading, onTap: () async{

              setState(() {
                loading = true;
              });
              final credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: verificationCodeController.text.toString());

              try{
                await auth.signInWithCredential(credential);
                if (!mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));
                
              }catch(e){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(e.toString());

              }

            }),

          ],
        ),
      ),

    );
  }
}
