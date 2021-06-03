import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BidGetDrawer extends StatefulWidget {
  const BidGetDrawer({Key key}) : super(key: key);

  @override
  _BidGetDrawerState createState() => _BidGetDrawerState();
}

class _BidGetDrawerState extends State<BidGetDrawer> {
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
                  child: CircleAvatar(
                    radius: 42.0,
                    child: Text(
                      currentUserSnapshot != null
                          ? currentUserSnapshot['full_name'][0]
                          : "U",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 20.0,
                      ),
                    ),
                    backgroundColor: AppColors.greyColor.withOpacity(0.3),
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
    if (currentUserSnapshot != null) setState(() {});
  }
}
