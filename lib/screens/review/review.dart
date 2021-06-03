import 'package:bid_get/screens/screen_exporter.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingAndReview extends StatefulWidget {
  const RatingAndReview({Key key}) : super(key: key);

  @override
  _RatingAndReviewState createState() => _RatingAndReviewState();
}

class _RatingAndReviewState extends State<RatingAndReview> {
  DocumentSnapshot currentUserSnapshot;
  final firebaseFirestore = FirebaseFirestore.instance;
  bool isLoading = true;

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
        title: Text("Ratings And Reviews"),
      ),
      drawer: BidGetDrawer(),
      body: Stack(
        children: [
          isLoading
              ? const SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyColor.withOpacity(0.2),
                              spreadRadius: 0.5,
                              blurRadius: 8,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40.0,
                              backgroundColor:
                                  AppColors.greyColor.withOpacity(0.3),
                              child: Text(
                                "I",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${currentUserSnapshot['full_name']}",
                                  style: TextStyle(
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 8.0),
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6.0),
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
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.asset(
                                            Common.assetsImages +
                                                tenders['project_category'] +
                                                ".jpg",
                                            fit: BoxFit.fill,
                                            height: 180.0,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "${tenders['project_title']}",
                                          style: TextStyle(
                                            color: AppColors.blueColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                        RatingBar.builder(
                                          initialRating:
                                              tenders['rating'].toDouble(),
                                          minRating:
                                              tenders['rating'].toDouble(),
                                          maxRating:
                                              tenders['rating'].toDouble(),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 30.0,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "${tenders['review']}",
                                          style: TextStyle(
                                            color: AppColors.greyColor,
                                            fontSize: 15.0,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
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
    );
  }

  void _getCurrentUserDetails() async {
    currentUserSnapshot = await Common.currentUserSnapshot();
    if (currentUserSnapshot != null) {
      isLoading = false;
      setState(() {});
    }
  }

  Stream tenderStream() {
    return firebaseFirestore
        .collection("Reviews")
        .where("user_id", isEqualTo: currentUserSnapshot['user_id'])
        .snapshots();
  }
}
