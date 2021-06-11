import 'dart:io';

import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:bid_get/utils/widgets/widget_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BidGetDrawer extends StatefulWidget {
  const BidGetDrawer({Key key}) : super(key: key);

  @override
  _BidGetDrawerState createState() => _BidGetDrawerState();
}

class _BidGetDrawerState extends State<BidGetDrawer> {
  File _image;
  bool isLoading = false;

  final firebaseFirestore = FirebaseFirestore.instance;
  DocumentSnapshot currentUserSnapshot;

  @override
  void initState() {
    _getCurrentUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: AppColors.primaryColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        )
                      : UserAvatar(
                          onPressed: () => _pickImage(),
                          usernameFirstCharacter: currentUserSnapshot != null
                              ? currentUserSnapshot['full_name'][0]
                              : "",
                          imageURL: currentUserSnapshot != null
                              ? currentUserSnapshot['profile_image']
                              : "",
                        ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  currentUserSnapshot != null
                      ? currentUserSnapshot['full_name']
                      : "---",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                const SizedBox(height: 2.5),
                Text(
                  currentUserSnapshot != null
                      ? currentUserSnapshot['email_address']
                      : "---",
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.8),
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppColors.whiteColor),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.tenderFeedRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.home_outlined),
                    title: Text("Home"),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.profileRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.person_outline),
                    title: Text("Profile"),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.tenderCompletedOrdersRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.list_alt),
                    title: Text("Completed Tenders"),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.tenderInProgressRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.access_time_outlined),
                    title: Text("In Progress Tenders"),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.tenderBidPlacedRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.alarm_add_outlined),
                    title: Text("Applied Tenders"),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.ratingsAndReviewRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.star_outline),
                    title: Text("Ratings & Reviews"),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.dashboardRoute, (route) => false),
                  child: ListTile(
                    tileColor: AppColors.greyColor.withOpacity(0.05),
                    leading: Icon(Icons.rss_feed),
                    title: Text("Accounts"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentUserDetails() async {
    currentUserSnapshot = await Common.currentUserSnapshot();
    if (currentUserSnapshot != null) if (mounted) setState(() {});
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
        isLoading = true;
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
                    isLoading = false;
                    _getCurrentUserDetails();
                  });
                }
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
          }
        });
      });
    }
  }
}
