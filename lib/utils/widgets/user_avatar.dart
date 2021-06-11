import 'package:bid_get/utils/utils_exporter.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatefulWidget {
  final String imageURL, usernameFirstCharacter;
  final double radius;
  final Function onPressed;

  const UserAvatar({
    Key key,
    @required this.imageURL,
    @required this.usernameFirstCharacter,
    this.radius = 42.0,
    this.onPressed,
  }) : super(key: key);

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: CircleAvatar(
        radius: widget.radius,
        child: (widget.imageURL == null || widget.imageURL.isEmpty)
            ? Text(
                widget.usernameFirstCharacter ?? "U",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20.0,
                ),
              )
            : null,
        backgroundImage: (widget.imageURL != null && widget.imageURL.isNotEmpty)
            ? NetworkImage(widget.imageURL)
            : null,
        backgroundColor: AppColors.greyColor.withOpacity(0.3),
      ),
    );
  }
}
