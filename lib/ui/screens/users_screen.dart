import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:form_using_firebase/service/local_notifications_service.dart';
import 'package:form_using_firebase/ui/screens/edit_screen.dart';
import 'package:form_using_firebase/ui/utils/utils.dart';

import '../../Constants/constants.dart';
import '../../service/notification_service.dart';
import 'form_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? country;
  Gender gender = Gender.Male;
  String? name;
  String? id;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();
  final ref = FirebaseFirestore.instance.collection('users');

  final editController = TextEditingController();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    super.initState();
    LocalNotificationService.initialize(context);
    NotificationService.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Users"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Some Error");
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              id = snapshot.data!.docs[index]['id'];
                              name = snapshot.data!.docs[index]['name'];
                              country = snapshot.data!.docs[index]['country'];

                              if (snapshot.data!.docs[index]['gender'] ==
                                  'Male') {
                                gender = Gender.Male;
                              } else {
                                gender = Gender.Female;
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditFormScreen(
                                            id: id.toString(),
                                            country: country.toString(),
                                            gender: gender,
                                            name: name.toString(),
                                          )));
                            },
                            title: Text(
                                snapshot.data!.docs[index]['name'].toString()),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .doc(snapshot
                                                .data!.docs[index]['id']
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Utils()
                                              .toastMessage("Data is Deleted");
                                        }).onError((error, stackTrace) {
                                          Utils()
                                              .toastMessage(error.toString());
                                        });
                                      },
                                      leading: const Icon(Icons.delete),
                                      title: const Text("Delete"),
                                    ))
                              ],
                            ),
                          );
                        }),
                  );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
