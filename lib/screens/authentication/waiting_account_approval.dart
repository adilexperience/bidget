import 'package:bid_get/utils/utils_exporter.dart';
import 'package:flutter/material.dart';

class WaitingAccountApproval extends StatefulWidget {
  static final String view = 'APPROVAL_SCREEN';

  @override
  _WaitingAccountApprovalState createState() => _WaitingAccountApprovalState();
}

class _WaitingAccountApprovalState extends State<WaitingAccountApproval> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Pending Verification"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: AppColors.primaryColor.withOpacity(0.85),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified,
              color: AppColors.whiteColor,
              size: 150,
            ),
            SizedBox(height: 20),
            Text(
              "Application Submitted",
              style: TextStyle(
                color: AppColors.whiteColor.withOpacity(0.9),
                fontSize: 25,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Thanks for signing up, your account is under review, you will be allowed to use application once the application from admin is approved.",
              style: TextStyle(
                color: AppColors.whiteColor.withOpacity(0.8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
