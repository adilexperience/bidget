import 'dart:io';

import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/screens/screen_exporter.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:bid_get/utils/widgets/widget_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key key,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final firebaseFirestore = FirebaseFirestore.instance;
  DocumentSnapshot currentUserSnapshot;

  bool isLoading = true;

  File _image;
  bool isImageLoading = false;

  @override
  void initState() {
    _getCurrentUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Profile"),
      ),
      drawer: BidGetDrawer(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            !isLoading
                ? Column(
                    children: [
                      const SizedBox(height: 20.0),
                      isImageLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            )
                          : UserAvatar(
                              onPressed: () => _pickImage(),
                              usernameFirstCharacter:
                                  currentUserSnapshot != null
                                      ? currentUserSnapshot['full_name'][0]
                                      : "",
                              imageURL: currentUserSnapshot != null
                                  ? currentUserSnapshot['profile_image']
                                  : "",
                            ),
                      const SizedBox(height: 10.0),
                      Text(
                        "${currentUserSnapshot['full_name']}",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Verified Bidder",
                            style: TextStyle(
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 8.0),
                          Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 20.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                            AppRoutes.ratingsAndReviewRoute),
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
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Admin Feedback",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    StreamBuilder(
                                      stream: firebaseFirestore
                                          .collection("Reviews")
                                          .where('user_id',
                                              isEqualTo: currentUserSnapshot[
                                                  'user_id'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data.docs.length} reviews",
                                            style: TextStyle(
                                              color: AppColors.greyColor,
                                              fontSize: 16.0,
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.star,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                            AppRoutes.tenderInProgressRoute),
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
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "In Progress Tenders",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    StreamBuilder(
                                      stream: firebaseFirestore
                                          .collection("Tenders")
                                          .where('assigned_to',
                                              isEqualTo: currentUserSnapshot[
                                                  'user_id'])
                                          .where('is_in_progress',
                                              isEqualTo: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data.docs.length} in a queue",
                                            style: TextStyle(
                                              color: AppColors.greyColor,
                                              fontSize: 16.0,
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.clock,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                            AppRoutes.tenderCompletedOrdersRoute),
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
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Completed Tenders",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    StreamBuilder(
                                      stream: firebaseFirestore
                                          .collection("Tenders")
                                          .where('is_completed',
                                              isEqualTo: true)
                                          .where('assigned_to',
                                              isEqualTo: currentUserSnapshot[
                                                  'user_id'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data.docs.length}",
                                            style: TextStyle(
                                              color: AppColors.greyColor,
                                              fontSize: 16.0,
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.tasks,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      InkWell(
                        onTap: () => _processWithdraw(),
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
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Withdraw Money",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${currentUserSnapshot['withdraw_available_double']} PKR",
                                      style: TextStyle(
                                        color: AppColors.greyColor,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.moneyCheck,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      InkWell(
                        onTap: () {
                          FirebaseAuth.instance.signOut().then(
                                (value) =>
                                    Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.loginRoute,
                                ),
                              );
                        },
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
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.doorClosed,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
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
                            AppColors.primaryColor),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _getCurrentUserDetails() async {
    currentUserSnapshot = await Common.currentUserSnapshot();
    if (currentUserSnapshot != null) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _pickImage() async {
    if (currentUserSnapshot == null ||
        currentUserSnapshot['user_id'].toString().isEmpty) {
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isImageLoading = true;
      });

      _image = File(pickedFile.path);
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('Users')
          .child(currentUserSnapshot['user_id'])
          .child(new DateTime.now().millisecondsSinceEpoch.toString());

      UploadTask userImageUpload = storageRef
          .child(new DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(_image);

      String userImageURL;
      await userImageUpload.then((res) async {
        res.ref.getDownloadURL().then((value) {
          userImageURL = value;

          //storing user image in profile of fire-store
          if (userImageURL != null) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUserSnapshot['user_id'])
                .update({'profile_image': userImageURL}).then(
              (value) {
                if (mounted) {
                  setState(() {
                    isImageLoading = false;
                    _getCurrentUserDetails();
                  });
                }
              },
            ).onError((error, stackTrace) {
              if (mounted) {
                setState(() {
                  isImageLoading = false;
                });
              }
              Common.showOnePrimaryButtonDialog(
                context: context,
                dialogMessage: error.toString(),
                primaryButtonText: "Okay",
              );
            });
          }
        });
      });
    }
  }

  void _processWithdraw() {
    if (currentUserSnapshot['withdraw_available_double'] > 0) {
      DocumentReference documentReference =
          firebaseFirestore.collection("PaymentRequests").doc();
      documentReference.set({
        'payment_request_id': documentReference.id,
        'amount_text': "${currentUserSnapshot['withdraw_available_text']}",
        'amount_double': "${currentUserSnapshot['withdraw_available_double']}",
        'email_address': "${currentUserSnapshot['email_address']}",
        'full_name': "${currentUserSnapshot['full_name']}",
        'under_review': true,
        'user_id': "${currentUserSnapshot['user_id']}",
      });
      firebaseFirestore
          .collection("Users")
          .doc(currentUserSnapshot['user_id'])
          .update({
        'withdraw_available_double': 0,
      });
      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage:
            "Withdraw Request Sent to admin. yoo will receive your funds shortly",
        primaryButtonText: "Great !",
        primaryButtonOnPressed: () => Navigator.of(context)
            .pushReplacementNamed(AppRoutes.dashboardRoute),
      );
    } else {
      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage: "You don't have sufficient funds for withdrawal",
        primaryButtonText: "Okay !",
      );
    }
  }
}
