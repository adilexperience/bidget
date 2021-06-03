import 'package:bid_get/screens/screen_exporter.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:bid_get/utils/widgets/widget_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final firebaseFirestore = FirebaseFirestore.instance;
  DocumentSnapshot currentUserSnapshot;

  @override
  void initState() {
    _getCurrentUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Accounts"),
      ),
      drawer: BidGetDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            currentUserSnapshot == null
                ? const SizedBox.shrink()
                : StreamBuilder(
                    stream: firebaseFirestore
                        .collection("Users")
                        .doc(currentUserSnapshot['user_id'])
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return PrimaryDashboardCard(
                          cardName: 'Total Earning',
                          value: "${snapshot.data['total_earning_double']} PKR",
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
            const SizedBox(height: 25.0),
            Row(
              children: [
                Expanded(
                  child: currentUserSnapshot == null
                      ? const SizedBox.shrink()
                      : StreamBuilder(
                          stream: firebaseFirestore
                              .collection("Orders")
                              .where('member_id',
                                  isEqualTo: currentUserSnapshot['user_id'])
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return PrimaryDashboardCard(
                                cardName: 'Total Orders',
                                value: "${snapshot.data.docs.length}",
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: currentUserSnapshot == null
                      ? const SizedBox.shrink()
                      : StreamBuilder(
                          stream: firebaseFirestore
                              .collection("Users")
                              .doc(currentUserSnapshot['user_id'])
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return PrimaryDashboardCard(
                                cardName: 'Available for Withdraw',
                                value:
                                    "${snapshot.data['withdraw_available_double']} PKR",
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            currentUserSnapshot == null
                ? const SizedBox.shrink()
                : StreamBuilder(
                    stream: firebaseFirestore
                        .collection("Users")
                        .doc(currentUserSnapshot['user_id'])
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return PrimaryDashboardCard(
                          cardName: 'Overall Rating',
                          value: "${snapshot.data['overall_rating']}",
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _getCurrentUserDetails() async {
    currentUserSnapshot = await Common.currentUserSnapshot();
    setState(() {});
  }
}
