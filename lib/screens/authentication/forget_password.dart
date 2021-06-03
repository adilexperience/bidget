import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:bid_get/utils/widgets/widget_exporter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    Key key,
  }) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailTextController = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        elevation: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                          ),
                          height: 65.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: AppColors.whiteColor,
                                  size: 22.0,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "We've got you covered. please provide us your email address. We will send you the instructions",
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0.0),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(80.0)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LabelAndInputField(
                            label: "Email",
                            hintText: "johndoe@gmail.com",
                            textController: emailTextController,
                            textInputType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 50.0),
                          InkWell(
                            onTap: () => _processForget(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 0.0),
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
                                  "Recover Password",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }

  void _processForget() {
    if (emailTextController.text.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailTextController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Valid Email Address is required"),
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        FocusScope.of(context).unfocus();
        isLoading = true;
      });
    }

    FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: emailTextController.text.trim(),
    )
        .then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Common.showOnePrimaryButtonDialog(
        context: context,
        dialogMessage: "Reset Link sent to your registered email address",
        primaryButtonText: "Okay !",
        primaryButtonOnPressed: () =>
            Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.loginRoute,
          (route) => false,
        ),
      );
    }).onError((error, stackTrace) {
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
}
