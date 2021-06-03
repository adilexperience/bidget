import 'package:bid_get/utils/utils_exporter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TenderOrderDetail extends StatefulWidget {
  final String tenderID;

  const TenderOrderDetail({
    Key key,
    this.tenderID,
  }) : super(key: key);

  @override
  _TenderOrderDetailState createState() => _TenderOrderDetailState();
}

class _TenderOrderDetailState extends State<TenderOrderDetail> {
  DocumentSnapshot tenderSnapshot, currentUserSnapshot;
  bool isLoading = true;
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
        title: Text(tenderSnapshot == null ? "" : "${tenderSnapshot['title']}"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    image: tenderSnapshot == null
                        ? null
                        : DecorationImage(
                            image: AssetImage(Common.assetsImages +
                                tenderSnapshot['category'] +
                                ".jpg"),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: tenderSnapshot == null
                      ? null
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor),
                          ),
                        ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          child: Container(
                            width: 120,
                            height: 1,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withOpacity(0.45),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "${tenderSnapshot['title']}",
                          style: TextStyle(fontSize: 20, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "${tenderSnapshot['description']}",
                          style: TextStyle(height: 1.6),
                        ),
                        const SizedBox(height: 10),
                        // Container(
                        //   child: SizedBox(
                        //     height: size.height * 0.5,
                        //     child: ListView.builder(
                        //       shrinkWrap: true,
                        //       itemCount: 10,
                        //       itemBuilder: (context, index) {
                        //         return false
                        //             ? ChatCard(
                        //                 isMe: true,
                        //                 message: "Wow Excellent",
                        //                 userImageURL:
                        //                     "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80",
                        //                 child: Text(
                        //                   "U",
                        //                   style: TextStyle(
                        //                     color: AppColors.whiteColor,
                        //                     fontSize: 20.0,
                        //                   ),
                        //                 ),
                        //               )
                        //             : ChatImageCard(
                        //                 isMe: true,
                        //                 imageURL:
                        //                     "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80",
                        //                 userImageURL:
                        //                     "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80",
                        //                 child: Text(
                        //                   "U",
                        //                   style: TextStyle(
                        //                     color: AppColors.whiteColor,
                        //                     fontSize: 20.0,
                        //                   ),
                        //                 ),
                        //               );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 4,
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //             vertical: 5.0, horizontal: 10.0),
                        //         decoration: BoxDecoration(
                        //           color: AppColors.whiteColor,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: AppColors.greyColor
                        //                   .withOpacity(0.2),
                        //               spreadRadius: 0.5,
                        //               blurRadius: 8,
                        //             ),
                        //           ],
                        //           borderRadius: BorderRadius.all(
                        //               Radius.circular(10.0)),
                        //         ),
                        //         child: TextFormField(
                        //           // controller: widget.textController,
                        //           // keyboardType: widget.textInputType,
                        //           decoration: InputDecoration(
                        //             hintText: "Type Message ...",
                        //             hintStyle: TextStyle(
                        //               color: AppColors.greyColor,
                        //             ),
                        //             border: InputBorder.none,
                        //           ),
                        //           maxLines: 1,
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10),
                        //     Expanded(
                        //       flex: 1,
                        //       child: Row(
                        //         children: [
                        //           InkWell(
                        //             // onTap: () => Get.offAllNamed(AppRoutes.HOME),
                        //             child: Container(
                        //               padding: EdgeInsets.symmetric(
                        //                 vertical: 12.0,
                        //                 horizontal: 12.0,
                        //               ),
                        //               decoration: BoxDecoration(
                        //                 color: AppColors.primaryColor,
                        //                 borderRadius: BorderRadius.only(
                        //                   topLeft: Radius.circular(10.0),
                        //                   bottomRight:
                        //                       Radius.circular(10.0),
                        //                   bottomLeft:
                        //                       Radius.circular(10.0),
                        //                 ),
                        //               ),
                        //               child: Image.asset(
                        //                   Common.assetsImages +
                        //                       "send.png"),
                        //             ),
                        //           ),
                        //           Icon(Icons.attach_file),
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                )
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

  void _getDetails() async {
    tenderSnapshot = await firebaseFirestore
        .collection("Tenders")
        .doc(widget.tenderID)
        .get();
    currentUserSnapshot = await Common.currentUserSnapshot();
    if (tenderSnapshot != null && currentUserSnapshot != null) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class ChatImageCard extends StatelessWidget {
  final bool isMe;
  final String imageURL, userImageURL;
  final Function onPressed;
  final Widget child;

  const ChatImageCard({
    Key key,
    @required this.isMe,
    @required this.imageURL,
    @required this.userImageURL,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: IntrinsicHeight(
            child: isMe
                ? CurrentUserImageCard(
                    imageURL: imageURL,
                    userImageURL: userImageURL,
                    onPressed: onPressed,
                    child: child,
                  )
                : OtherUserImageCard(
                    imageURL: imageURL,
                    userImageURL: userImageURL,
                    onPressed: onPressed,
                    child: child,
                  ),
          ),
        ),
      ],
    );
  }
}

class CurrentUserImageCard extends StatelessWidget {
  final String imageURL, userImageURL;
  final Function onPressed;
  final Widget child;

  const CurrentUserImageCard({
    Key key,
    @required this.imageURL,
    @required this.userImageURL,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(imageURL),
          ),
        ),
        const SizedBox(width: 10.0),
        Align(
          alignment: Alignment.bottomLeft,
          child: CircleAvatar(
            radius: 20.0,
            child: child,
            backgroundColor: AppColors.greyColor.withOpacity(0.2),
            backgroundImage: child == null ? NetworkImage(userImageURL) : null,
          ),
        ),
      ],
    );
  }
}

class OtherUserImageCard extends StatelessWidget {
  final String imageURL, userImageURL;
  final Function onPressed;
  final Widget child;

  const OtherUserImageCard({
    Key key,
    @required this.imageURL,
    @required this.userImageURL,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: CircleAvatar(
            radius: 20.0,
            child: child,
            backgroundColor: AppColors.greyColor.withOpacity(0.2),
            backgroundImage: child == null ? NetworkImage(userImageURL) : null,
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          flex: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(imageURL),
          ),
        ),
      ],
    );
  }
}

class ChatCard extends StatelessWidget {
  final bool isMe;
  final String message, userImageURL;
  final Widget child;

  const ChatCard({
    Key key,
    @required this.isMe,
    @required this.message,
    @required this.userImageURL,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: isMe
              ? CurrentUserCard(
                  message: message,
                  userImageURL: userImageURL,
                  child: child,
                )
              : OtherUserCard(
                  message: message,
                  userImageURL: userImageURL,
                  child: child,
                ),
        ),
      ],
    );
  }
}

class CurrentUserCard extends StatelessWidget {
  final String userImageURL, message;
  final Widget child;

  const CurrentUserCard({
    Key key,
    @required this.userImageURL,
    @required this.message,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: Text(
            message,
            style: TextStyle(
              color: AppColors.whiteColor,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        CircleAvatar(
          radius: 20.0,
          child: child,
          backgroundColor: AppColors.greyColor.withOpacity(0.2),
          backgroundImage: child == null ? NetworkImage(userImageURL) : null,
        ),
      ],
    );
  }
}

class OtherUserCard extends StatelessWidget {
  final String userImageURL, message;
  final Widget child;

  const OtherUserCard({
    Key key,
    @required this.userImageURL,
    @required this.message,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        CircleAvatar(
          radius: 20.0,
          child: child,
          backgroundColor: AppColors.greyColor.withOpacity(0.2),
          backgroundImage: child == null ? NetworkImage(userImageURL) : null,
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
