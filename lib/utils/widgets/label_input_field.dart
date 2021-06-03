import 'package:bid_get/utils/utils_exporter.dart';
import 'package:flutter/material.dart';

class LabelAndInputField extends StatefulWidget {
  final String label, hintText;
  final TextInputType textInputType;
  final TextEditingController textController;

  const LabelAndInputField({
    Key key,
    @required this.label,
    @required this.hintText,
    this.textInputType,
    this.textController,
  }) : super(key: key);

  @override
  _LabelAndInputFieldState createState() => _LabelAndInputFieldState();
}

class _LabelAndInputFieldState extends State<LabelAndInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextFormField(
            controller: widget.textController,
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppColors.greyColor,
              ),
              border: InputBorder.none,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
