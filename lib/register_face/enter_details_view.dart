import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/common/utils/custom_text_field.dart';
import 'package:face_auth/common/views/custom_button.dart';
import 'package:face_auth/constants/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../common/utils/custom_snackbar.dart';
import '../main.dart';

class EnterDetailsView extends StatefulWidget {
  final File image;
  final Map<dynamic, dynamic> imageJSON;
  // final FaceFeatures faceFeatures;
  const EnterDetailsView({
    Key? key,
    required this.image,
    required this.imageJSON,
    // required this.faceFeatures,
  }) : super(key: key);

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  bool isRegistering = false;
  final _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
  final _empCodeFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _empCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Add Details"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  formFieldKey: _formFieldKey,
                  controller: _nameController,
                  hintText: "Name",
                  validatorText: "Name cannot be empty",
                ),
                CustomTextField(
                  formFieldKey: _empCodeFieldKey,
                  controller: _empCodeController,
                  hintText: "Employee Code",
                  validatorText: "Employee code cannot be empty",
                ),
                CustomButton(
                  text: "Register Now",
                  onTap: () async {
                    if (_formFieldKey.currentState!.validate() &&
                        _empCodeFieldKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: accentColor,
                          ),
                        ),
                      );
                      FirebaseStorage storage = FirebaseStorage.instance;
                      final reference = storage
                          .ref("users/")
                          .child("image/${DateTime.now()}");
                      print(widget.image.path);

                      print(widget.image);
                      final uploadTask = reference.putFile(widget.image);
                      var imageURL = await uploadTask
                          .then((p0) => p0.ref.getDownloadURL());

                      String userId = Uuid().v1();
                      Map<String, dynamic> user = {
                        "id": userId,
                        "name": _nameController.text.trim().toUpperCase(),
                        "empCode": _empCodeController.text.trim().toUpperCase(),
                        "image": "",
                        "registeredOn": DateTime.now().millisecondsSinceEpoch,
                        "auth_json": widget.imageJSON
                      };

                      // print(widget.imageJSON["bitmap"]);
                      // print(widget.imageJSON["imageType"]);
                      //
                      // final userDataBox = Hive.box<userdata>('userDataDetails');
                      // final UserData = userdata(
                      //     _nameController.text.trim().toUpperCase(),
                      //     _empCodeController.text.trim().toUpperCase(),
                      //     ImageJson(widget.imageJSON["bitmap"],
                      //         widget.imageJSON["imageType"]));
                      // await userDataBox.add(UserData);
                      //
                      // final userDataList = userDataBox.values.toList();
                      //
                      // for (final userData in userDataList) {
                      //   print(
                      //       'Name: ${userData.name}, Employee: ${userData.empCode},Image: ${userData.image.bitmap}, Type: ${userData.image.type}');
                      // }

                      // userDataBox.clear();

                      print(user);
                      await FirebaseFirestore.instance
                          .collection("users")
                          .add(user)
                          .then((value) {
                        print(value.id);
                        Navigator.of(context).pop();
                        CustomSnackBar.successSnackBar("Registration Success!");
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                          //Reaches HomePage
                          // Navigator.of(context)
                          //   ..pop()
                          //   ..pop()
                          //   ..pop();
                        });
                      }).catchError((e) {
                        log("Registration Error: $e");
                        Navigator.of(context).pop();
                        CustomSnackBar.errorSnackBar(
                            "Registration Failed! Try Again.");
                      });

                      Navigator.of(context).pop();
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                        //Reaches HomePage
                        // Navigator.of(context)
                        //   ..pop()
                        //   ..pop()
                        //   ..pop();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
