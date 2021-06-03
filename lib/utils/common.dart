import 'package:bid_get/modal/category_modal.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Common {
  static const String applicationName = "BidGet";
  static const String assetsImages = "assets/images/";
  static const String assetsIcons = "assets/icons/";
  static const String assetsAnimations = "assets/animation/";

  static List<CategoryModal> categories = [
    CategoryModal(categoryName: "All"),
    CategoryModal(
      categoryName: "Road",
      imageURL: Common.assetsImages + "road.jpg",
    ),
    CategoryModal(
      categoryName: "Construction",
      imageURL: Common.assetsImages + "construction.jpg",
    ),
    CategoryModal(
      categoryName: "Pipeline",
      imageURL: Common.assetsImages + "pipeline.jpg",
    ),
    CategoryModal(
      categoryName: "Others",
      imageURL: Common.assetsImages + "construction.jpg",
    ),
  ];

  static showOnePrimaryButtonDialog({
    @required BuildContext context,
    @required String dialogMessage,
    @required String primaryButtonText,
    Function primaryButtonOnPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Common.applicationName),
        content: new Text(dialogMessage),
        actions: <Widget>[
          InkWell(
            onTap: primaryButtonOnPressed ?? () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                primaryButtonText,
                style: TextStyle(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static bool isUserLoggedIn() {
    if (FirebaseAuth.instance.currentUser == null)
      return false;
    else
      return true;
  }

  static Future<DocumentSnapshot> currentUserSnapshot() async {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseFirestore = FirebaseFirestore.instance;

    final snapshot = await firebaseFirestore
        .collection("Users")
        .doc(firebaseAuth.currentUser.uid)
        .get();
    return snapshot;
  }
}
