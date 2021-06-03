import 'package:bid_get/utils/utils_exporter.dart';
import 'package:flutter/material.dart';

class PrimaryDashboardCard extends StatelessWidget {
  final String value, cardName;

  const PrimaryDashboardCard({
    Key key,
    @required this.value,
    @required this.cardName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 150.0,
      ),
      child: Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: AppColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              cardName,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
