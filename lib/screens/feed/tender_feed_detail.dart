import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TenderFeedDetail extends StatefulWidget {
  final String tenderID;
  const TenderFeedDetail({
    Key key,
    this.tenderID,
  }) : super(key: key);

  @override
  _TenderFeedDetailState createState() => _TenderFeedDetailState();
}

class _TenderFeedDetailState extends State<TenderFeedDetail> {
  TextEditingController bidAmountController = TextEditingController();
  DocumentSnapshot tenderSnapshot, currentUserSnapshot;
  bool isLoading = true, hasAlreadyBidded;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          tenderSnapshot == null ? "" : "${tenderSnapshot['title']}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                image: tenderSnapshot != null
                    ? DecorationImage(
                        image: AssetImage(Common.assetsImages +
                            tenderSnapshot['category'] +
                            ".jpg"),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: tenderSnapshot == null
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor),
                      ),
                    )
                  : const SizedBox(),
            ),
            !isLoading
                ? Container(
                    margin: EdgeInsets.only(top: size.height * 0.45),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            child: Container(
                              width: 80,
                              height: 1,
                              decoration: BoxDecoration(
                                color: AppColors.greyColor.withOpacity(0.45),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "${tenderSnapshot['title']}",
                            style: TextStyle(fontSize: 20, height: 1.5),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "${tenderSnapshot['description']}",
                            style: TextStyle(
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 10),
                          tenderSnapshot['is_completed']
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.greyColor
                                            .withOpacity(0.2),
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
                                    vertical: 3.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Review",
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            const SizedBox(height: 2.5),
                                            StreamBuilder(
                                              stream: firebaseFirestore
                                                  .collection("Reviews")
                                                  .where('user_id',
                                                      isEqualTo:
                                                          currentUserSnapshot[
                                                              'user_id'])
                                                  .where('tender_id',
                                                      isEqualTo:
                                                          widget.tenderID)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating: snapshot
                                                            .data
                                                            .docs[0]['rating']
                                                            .toDouble(),
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 26.0,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      Text(
                                                        "${snapshot.data.docs[0]['review']}",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .greyColor,
                                                          fontSize: 16.0,
                                                        ),
                                                        maxLines: 5,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          hasAlreadyBidded
                              ? const SizedBox.shrink()
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: Text(
                                        "Enter Your Bid Amount:",
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.greyColor,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: bidAmountController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: tenderSnapshot[
                                                        'starting_bid_double']
                                                    .toString() ??
                                                "20,000",
                                            hintStyle: TextStyle(
                                              color: AppColors.greyColor,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          hasAlreadyBidded
                              ? const SizedBox()
                              : const SizedBox(height: 10),
                          hasAlreadyBidded
                              ? const SizedBox.shrink()
                              : InkWell(
                                  onTap: () => _processBidAmount(),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 0.0),
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
                                        "Bid Now",
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          letterSpacing: 0.7,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
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

  void _getDetails() async {
    tenderSnapshot = await firebaseFirestore
        .collection("Tenders")
        .doc(widget.tenderID)
        .get();
    currentUserSnapshot = await Common.currentUserSnapshot();
    hasAlreadyBidded = await checkIfAlreadyBidded();
    if (tenderSnapshot != null &&
        currentUserSnapshot != null &&
        hasAlreadyBidded != null) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _processBidAmount() {
    if (bidAmountController.text.trim().isEmpty ||
        double.parse(bidAmountController.text.trim().toString()) <=
            tenderSnapshot['starting_bid_double']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Bid Amount is required and must be greater than starting bid amount"),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });

    firebaseFirestore
        .collection("Tenders")
        .doc(tenderSnapshot['tender_id'])
        .update(
      {
        'bidders': FieldValue.arrayUnion(
          [currentUserSnapshot['user_id']],
        ),
      },
    );

    firebaseFirestore
        .collection("Tenders")
        .doc(tenderSnapshot['tender_id'])
        .collection("Bidders")
        .doc(currentUserSnapshot['user_id'])
        .set({
      'bidder_id': currentUserSnapshot['user_id'],
      'bid_amount': double.parse(bidAmountController.text.trim()),
      'bid_amount_text': bidAmountController.text.trim() + " PKR"
    }).then((value) {
      setState(() {
        isLoading = false;
        Common.showOnePrimaryButtonDialog(
          context: context,
          dialogMessage:
              "Bid Placed on the tender. Admin has received it and will review it.\n Keep Exploring BidGet, Thank you",
          primaryButtonText: "Sure !",
          primaryButtonOnPressed: () =>
              Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.dashboardRoute,
            (route) => false,
          ),
        );
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<bool> checkIfAlreadyBidded() async {
    var alreadyBidDocument = await firebaseFirestore
        .collection("Tenders")
        .doc(widget.tenderID)
        .collection("Bidders")
        .doc(currentUserSnapshot['user_id'])
        .get();
    return alreadyBidDocument.exists;
  }
}
