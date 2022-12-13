import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_using_firebase/ui/utils/utils.dart';
import 'package:form_using_firebase/ui/widget/round_button.dart';
import '../../Constants/constants.dart';
import '../../Model/user_model.dart';

// ignore: must_be_immutable
class EditFormScreen extends StatefulWidget {
  UserM user;

  EditFormScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditFormScreen> createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  bool check = false;
  final firestore = FirebaseFirestore.instance.collection('users');
  final ref = FirebaseFirestore.instance.collection('users');
  bool? checkboxIconFormFieldValue = false;
  List<Country> dropdownlist = [];
  bool loading = false;
  final _nameController = TextEditingController();
  final _formkey1 = GlobalKey<FormState>();
  Gender? gender = Gender.Male;
  Country dropdownValue = Country.country;
  @override
  void initState() {
    for (var value in Country.values) {
      dropdownlist.add(value);
    }

    super.initState();
    _nameController.text = widget.user.name;
    if (widget.user.gender == 'Male') {
      gender = Gender.Male;
    } else {
      gender = Gender.Female;
    }
    if (widget.user.country == 'Pakistan') {
      dropdownValue = Country.Pakistan;
    } else if (widget.user.country == 'China') {
      dropdownValue = Country.China;
    } else if (widget.user.country == 'India') {
      dropdownValue = Country.India;
    } else {
      dropdownValue = Country.country;
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  void update(UserM user) {
    setState(() {
      loading = true;
    });
    ref.doc(widget.user.id).update({
      'name': user.name,
      'gender': user.gender,
      'country': user.country
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
                    children: [
                      TextFormField(
                        // onChanged: (),
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        decoration: const InputDecoration(
                            hintText: 'Name',
                            // helperText: 'enter email e.g abc@xyz.com',
                            prefixIcon: Icon(Icons.abc)),
                        validator: (input) =>
                            input!.isEmpty ? "Enter name" : null,
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
                        child: DropdownButtonFormField<Country>(
                          menuMaxHeight: 350,
                          value: dropdownValue,
                          validator: (value) => value!.name == 'country'
                              ? 'select country'
                              : null,
                          items: dropdownlist.map((Country items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items.name,
                                ));
                          }).toList(),
                          onChanged: (Country? value) {
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
                  if (_formkey1.currentState!.validate()) {
                    UserM user = UserM(
                        country: dropdownValue.name,
                        gender: gender!.name,
                        id: widget.user.id,
                        name: _nameController.text.toString());
                    update(user);
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
