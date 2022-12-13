import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_using_firebase/ui/utils/utils.dart';
import 'package:form_using_firebase/ui/widget/round_button.dart';
import '../../Constants/constants.dart';

// ignore: must_be_immutable
class EditFormScreen extends StatefulWidget {
  String id;
  String name;
  Gender gender;
  String country;
  EditFormScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.country,
      required this.gender});

  @override
  State<EditFormScreen> createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  bool check = false;
  final firestore = FirebaseFirestore.instance.collection('users');
  final ref = FirebaseFirestore.instance.collection('users');
  bool? checkboxIconFormFieldValue = false;
  List<String> dropdownlist = ['country', 'Pakistan', 'India', 'China'];
  bool loading = false;
  final _nameController = TextEditingController();
  final _formkey1 = GlobalKey<FormState>();
  Gender? gender = Gender.Male;
  String dropdownValue = 'country';
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    gender = widget.gender;
    log(gender!.name);
    dropdownValue = widget.country;
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  void update() {
    setState(() {
      loading = true;
    });
    ref.doc(widget.id).update({
      'name': _nameController.text.toString(),
      'gender': gender!.name,
      'country': dropdownValue
    }).then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("User is updated");
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Edit Form"))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              Form(
                  key: _formkey1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        // onChanged: (),
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        decoration: const InputDecoration(
                            hintText: 'Name',
                            // helperText: 'enter email e.g abc@xyz.com',
                            prefixIcon: Icon(Icons.abc)),
                        validator: (input) {
                          input = _nameController.text;
                          if (input.isEmpty) {
                            check = true;
                          } else {
                            check = false;
                          }
                          input.isEmpty ? "Enter name" : null;
                          return null;
                          // input!.isEmpty ? "Enter name" : null;
                        },
                      ),
                      Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(Gender.Male.name),
                            leading: Radio<Gender>(
                              value: Gender.Male,
                              groupValue: gender,
                              onChanged: (Gender? value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(Gender.Female.name),
                            leading: Radio<Gender>(
                              value: Gender.Female,
                              groupValue: gender,
                              onChanged: (Gender? value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonFormField<String?>(
                          menuMaxHeight: 350,
                          value: dropdownValue,
                          validator: (value) =>
                              value == 'country' ? 'select country' : null,
                          items: dropdownlist.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                ));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                        ),
                      ),
                      // CheckboxListTileFormField(
                      //   title: const Text('check terms and conditions'),
                      //   // onSaved: (bool? value) {
                      //   //   // print(value);
                      //   // },
                      //   validator: (bool? value) {
                      //     if (value!) {
                      //       return null;
                      //     } else {
                      //       return 'Please check terms and conditions';
                      //     }
                      //   },
                      //   autovalidateMode: AutovalidateMode.always,
                      // ),
                    ],
                  )),
              const SizedBox(height: 50),
              RoundButton(
                title: 'Submit',
                loading: loading,
                onTap: () {
                  if (check == true) {
                    Utils().toastMessage("Please Enter Name");
                  } else if (_formkey1.currentState!.validate()) {
                    update();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
