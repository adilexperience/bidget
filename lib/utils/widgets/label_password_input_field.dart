import 'package:bid_get/utils/utils_exporter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LabelPasswordInputField extends StatefulWidget {
  final String label, hintText;
  final TextEditingController textController;

  const LabelPasswordInputField(
      {Key key, this.label, this.hintText, this.textController})
      : super(key: key);

  @override
  _LabelPasswordInputFieldState createState() =>
      _LabelPasswordInputFieldState();
}

class _LabelPasswordInputFieldState extends State<LabelPasswordInputField> {
  bool obscure = true;

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
            keyboardType: TextInputType.emailAddress,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppColors.greyColor,
              ),
              border: InputBorder.none,
              suffixIcon: GestureDetector(
                onTap: () => toggleObscure(),
                child: obscure
                    ? Icon(
                        FontAwesomeIcons.eyeSlash,
                        color: AppColors.greyColor,
                        size: 20,
                      )
                    : Icon(
                        FontAwesomeIcons.eye,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
              ),
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  void toggleObscure() {
    setState(() {
      obscure = !obscure;
    });
  }
}
