import 'package:bid_get/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryBlock extends StatelessWidget {
  final bool isActive;
  final String title;

  CategoryBlock({
    Key key,
    this.isActive,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, top: 8),
      margin: EdgeInsets.only(right: 10, bottom: 2.0, top: 2.0),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.29),
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: isActive
            ? TextStyle(
                color: AppColors.whiteColor,
              )
            : TextStyle(
                color: AppColors.blackColor,
              ),
      ),
    );
  }
}
