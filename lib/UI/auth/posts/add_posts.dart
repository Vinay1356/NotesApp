import 'package:firebase_connections_tutorials/UI/auth/posts/post_screen.dart';
import 'package:firebase_connections_tutorials/Utils/Utils.dart';
import 'package:firebase_connections_tutorials/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 5),),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: const InputDecoration(
                hintText: 'what is in your mind',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    'title': postController.text.toString(),
                    'id': id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}