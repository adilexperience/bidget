import 'package:bid_get/screens/screen_exporter.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InProgressTenders extends StatefulWidget {
  const InProgressTenders({Key key}) : super(key: key);

  @override
  _InProgressTendersState createState() => _InProgressTendersState();
}

class _InProgressTendersState extends State<InProgressTenders> {
  DocumentSnapshot currentUserSnapshot;
  final firebaseFirestore = FirebaseFirestore.instance;

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
        title: Text("In Progress Tenders"),
      ),
      drawer: BidGetDrawer(),
      body: Stack(
        children: [
          currentUserSnapshot == null
              ? const SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: tenderStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot tenders =
                                      snapshot.data.docs[index];
                                  return InkWell(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TenderOrderDetail(
                                                tenderID: tenders['tender_id'],
                                              )),
                                    ),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 180.0,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.greyColor
                                                          .withOpacity(0.2),
                                                      spreadRadius: 0.5,
                                                      blurRadius: 8,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      Common.assetsImages +
                                                          tenders['category'] +
                                                          ".jpg",
                                                    ),
                                                    fit: BoxFit.fill,
                                                    colorFilter:
                                                        new ColorFilter.mode(
                                                      AppColors.blackColor
                                                          .withOpacity(0.8),
                                                      BlendMode.dstATop,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                right: 10,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 25.0,
                                                    vertical: 5.0,
                                                  ),
                                                  child: Text(
                                                    "Project Budget: ${tenders['project_budget']} PKR",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 8.0,
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.solidClock,
                                                    color: Colors.green,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12.0),
                                          Text(
                                            "${tenders['title']}",
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              letterSpacing: 0.8,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            "${tenders['description']}",
                                            style: TextStyle(
                                              color: AppColors.greyColor,
                                              fontSize: 16.0,
                                              height: 1.3,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                          ),
                                          const SizedBox(height: 10.0),
                                          Divider(thickness: 1.0),
                                          const SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          currentUserSnapshot == null
              ? Positioned.fill(
                  child: Container(
                    color: AppColors.blackColor.withOpacity(0.25),
                  ),
                )
              : const SizedBox.shrink(),
          currentUserSnapshot == null
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
    );
  }

  void _getCurrentUserDetails() async {
    currentUserSnapshot = await Common.currentUserSnapshot();
    setState(() {});
  }

  Stream tenderStream() {
    return firebaseFirestore
        .collection("Tenders")
        .where("is_in_progress", isEqualTo: true)
        .where("assigned_to", isEqualTo: currentUserSnapshot['user_id'])
        .snapshots();
  }
}
