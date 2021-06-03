import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:bid_get/utils/widgets/widget_exporter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({
    Key key,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Image.asset(
                        Common.assetsIcons + "application_icon.png",
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Login and pick from where you've left",
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
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
                          SizedBox(height: 20.0),
                          LabelPasswordInputField(
                            label: "Password",
                            hintText: "* * * * * * * *",
                            textController: passwordTextController,
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.forgetPasswordRoute),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          InkWell(
                            onTap: () => _processLogin(),
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
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.signupRoute,
                                (route) => false),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Register Now",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
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

  void _processLogin() {
    if (emailTextController.text.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailTextController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Valid Email Address is required"),
        ),
      );
      return;
    } else if (passwordTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password is required"),
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
        .signInWithEmailAndPassword(
      email: emailTextController.text.trim(),
      password: passwordTextController.text.trim(),
    )
        .then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.tenderFeedRoute,
        (route) => false,
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
