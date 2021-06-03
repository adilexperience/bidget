import 'package:bid_get/routes/app_routes.dart';
import 'package:bid_get/screens/screen_exporter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bid Get',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashRoute,
      routes: {
        AppRoutes.splashRoute: (context) => Splash(),
        AppRoutes.loginRoute: (context) => Login(),
        AppRoutes.signupRoute: (context) => Signup(),
        AppRoutes.forgetPasswordRoute: (context) => ForgetPassword(),
        AppRoutes.waitingAccountApprovalRoute: (context) =>
            WaitingAccountApproval(),
        AppRoutes.dashboardRoute: (context) => Dashboard(),
        AppRoutes.drawerRoute: (context) => BidGetDrawer(),
        AppRoutes.tenderFeedRoute: (context) => TenderFeed(),
        AppRoutes.tenderDetailFeedRoute: (context) => TenderFeedDetail(),
        AppRoutes.profileRoute: (context) => Profile(),
        AppRoutes.tenderCompletedOrdersRoute: (context) =>
            CompletedTenderOrders(),
        AppRoutes.tenderInProgressRoute: (context) => InProgressTenders(),
        AppRoutes.tenderBidPlacedRoute: (context) => BidPlacedTenders(),
        AppRoutes.tenderOrderDetailRoute: (context) => TenderOrderDetail(),
        AppRoutes.ratingsAndReviewRoute: (context) => RatingAndReview(),
      },
    );
  }
}
