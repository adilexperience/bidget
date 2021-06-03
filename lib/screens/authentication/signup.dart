import 'dart:io';

import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:bid_get/utils/widgets/widget_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fullNameTextController = new TextEditingController();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  bool isLoading = false;

  File _idCardFrontImageFile, _idCardBackImageFile;
  final _idCardFrontImagePicker = ImagePicker(),
      _idCardBackImagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Create account and start your journey with us",
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0.0),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(80.0)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LabelAndInputField(
                            label: "Full Name",
                            hintText: "John Doe",
                            textController: fullNameTextController,
                            textInputType: TextInputType.text,
                          ),
                          const SizedBox(height: 20.0),
                          LabelAndInputField(
                            label: "Email",
                            hintText: "johndoe@gmail.com",
                            textController: emailTextController,
                            textInputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20.0),
                          LabelPasswordInputField(
                            label: "Password",
                            hintText: "* * * * * * * *",
                            textController: passwordTextController,
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () => getFrontIDImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.greyColor.withOpacity(0.2),
                                    spreadRadius: 0.5,
                                    blurRadius: 8,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Front Side Image of CNIC",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  _idCardFrontImageFile == null
                                      ? Image.asset(
                                          Common.assetsImages + "id_front.jpg",
                                          height: 100.0,
                                          width: 90.0,
                                        )
                                      : Image.file(
                                          _idCardFrontImageFile,
                                          height: 100.0,
                                          width: 90.0,
                                        ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () => getBackIDImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.greyColor.withOpacity(0.2),
                                    spreadRadius: 0.5,
                                    blurRadius: 8,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Back Side Image of CNIC",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  _idCardBackImageFile == null
                                      ? Image.asset(
                                          Common.assetsImages + "id_back.jpg",
                                          height: 100.0,
                                          width: 90.0,
                                        )
                                      : Image.file(
                                          _idCardBackImageFile,
                                          height: 100.0,
                                          width: 90.0,
                                        ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () => _processSignup(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 0.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.loginRoute,
                              (route) => false,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: "Login now",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Positioned.fill(
                  child: Container(
                    color: AppColors.blackColor.withOpacity(0.25),
                  ),
                )
              : const SizedBox.shrink(),
          isLoading
              ? Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Future getBackIDImage() async {
    final pickedFile =
        await _idCardBackImagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _idCardBackImageFile = File(pickedFile.path);
      }
    });
  }

  Future getFrontIDImage() async {
    final pickedFile =
        await _idCardFrontImagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _idCardFrontImageFile = File(pickedFile.path);
      }
    });
  }

  void _processSignup() {
    if (fullNameTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Full Name is required"),
        ),
      );
      return;
    } else if (emailTextController.text.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailTextController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Valid Email Address is required"),
        ),
      );
      return;
    } else if (passwordTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password is required"),
        ),
      );
      return;
    } else if (_idCardBackImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Identity Card Back Image is required"),
        ),
      );
      return;
    } else if (_idCardFrontImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Identity Card Front Image is required"),
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailTextController.text.trim(),
      password: passwordTextController.text.trim(),
    )
        .then((value) async {
      //reference to store user id card images to storage
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('Users').child(value.user.uid);

      UploadTask frontIDUploadTask = storageRef
          .child(new DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(_idCardFrontImageFile);
      UploadTask backIDUploadTask = storageRef
          .child(new DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(_idCardFrontImageFile);

      //uploading the user id card images to storage
      var frontIDCardURL, backIDCardURL;
      await frontIDUploadTask
          .then((res) => frontIDCardURL = res.ref.getDownloadURL());
      await backIDUploadTask
          .then((res) => backIDCardURL = res.ref.getDownloadURL());

      //storing user data in profile of fire-store
      FirebaseFirestore.instance.collection("Users").doc(value.user.uid).set({
        'user_id': value.user.uid,
        'full_name': fullNameTextController.text.trim(),
        'email_address': emailTextController.text.trim(),
        'front_id_image': await frontIDCardURL,
        'back_id_image': await backIDCardURL,
        'profile_image': "",
        'overall_rating': 0,
        'is_active': false,
        'total_earning_double': 0,
        'withdraw_available_double': 0,
      }).then(
        (value) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.waitingAccountApprovalRoute,
            (route) => false,
          );
        },
      ).onError((error, stackTrace) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Common.showOnePrimaryButtonDialog(
          context: context,
          dialogMessage: error.toString(),
          primaryButtonText: "Okay",
        );
      });
    }).onError((error, stackTrace) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage: error.toString(),
        primaryButtonText: "Okay",
      );
    });
  }
}
