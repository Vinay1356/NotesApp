import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connections_tutorials/UI/auth/login_screen.dart';
import 'package:firebase_connections_tutorials/UI/auth/posts/add_posts.dart';
import 'package:firebase_connections_tutorials/Utils/Utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          title: const Center(child: Text('Post',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 5),)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: searchFilter,
                decoration: const InputDecoration(
                  icon: Icon(Icons.filter_alt),
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref.child(FirebaseAuth.instance.currentUser!.uid),
                  defaultChild: const Text('Loading'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();

                    if (searchFilter.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title,snapshot.child('id').value.toString());
                                  },
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                )),
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                )),
                          ],
                        ),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase().toString())) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(
                          snapshot.child('id').value.toString(),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPostScreen(),
                ));
          },
          child: const Icon(Icons.add),
        ));
  }
  Future<void> showMyDialog(String title,String id) async{
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Edit'
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Cancel')),
            TextButton(onPressed: (){
              Navigator.pop(context);
              ref.child(id).update({
                'title': editController.text.toString()
              }).then((value) {
                Utils().toastMessage('Post Updated');

              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            }, child: const Text('Update'))
          ],
        );
      }
    );

  }
}

// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return CircularProgressIndicator();
// } else {
// Map<dynamic, dynamic> map =
// snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
//
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['id']),
// );
// });
// }
// })),
