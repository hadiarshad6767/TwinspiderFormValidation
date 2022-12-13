import 'dart:async';
import 'dart:developer';

import 'package:checkbox_formfield/checkbox_list_tile_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:form_using_firebase/ui/utils/utils.dart';

import 'package:form_using_firebase/ui/widget/round_button.dart';

import '../../Constants/constants.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final firestore = FirebaseFirestore.instance.collection('users');
  bool? checkboxIconFormFieldValue = false;
  List<String> dropdownlist = ['country', 'Pakistan', 'India', 'China'];
  bool loading = false;
  final _nameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Gender? gender = Gender.Male;
  String dropdownValue = 'country';

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  void submit() {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    setState(() {
      loading = true;
    });
    firestore.doc(id).set({
      'id': id,
      'name': _nameController.text.toString(),
      'gender': gender!.name,
      'country': dropdownValue
    }).then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("User Added");
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
      appBar: AppBar(title: const Center(child: Text("Form"))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        decoration: const InputDecoration(
                            hintText: 'Name',
                            // helperText: 'enter email e.g abc@xyz.com',
                            prefixIcon: Icon(Icons.abc)),
                        validator: (input) {
                          input!.isEmpty ? "Enter name" : null;
                          return null;
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
                                  debugPrint("Male");
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
                                  debugPrint("Female");
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
                      CheckboxListTileFormField(
                        title: const Text('Check terms and conditions'),
                        // onSaved: (bool? value) {
                        //   // print(value);
                        // },
                        validator: (bool? value) {
                          if (value!) {
                            return null;
                          } else {
                            return 'Please check terms and conditions';
                          }
                        },
                        autovalidateMode: AutovalidateMode.always,
                      ),
                    ],
                  )),
              const SizedBox(height: 50),
              RoundButton(
                title: 'Submit',
                loading: loading,
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    submit();
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
