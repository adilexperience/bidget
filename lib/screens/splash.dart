import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/utils/utils_exporter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({
    Key key,
  }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _runSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(),
            Column(
              children: [
                LottieBuilder.asset(
                  "${Common.assetsAnimations}splash_animation.json",
                  height: 300.0,
                ),
                const SizedBox(height: 10.0),
                Text(
                  Common.applicationName,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            LottieBuilder.asset(
              "${Common.assetsAnimations}loading.json",
              height: 90.0,
            ),
          ],
        ),
      ),
    );
  }

  void _runSplash() async {
    Future.delayed(const Duration(seconds: 5), () {
      if (Common.isUserLoggedIn()) {
        Common.currentUserSnapshot().then((value) {
          if (value['is_active']) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.tenderFeedRoute, (route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.waitingAccountApprovalRoute, (route) => false);
          }
        });
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.loginRoute, (route) => false);
      }
    });
  }
}
