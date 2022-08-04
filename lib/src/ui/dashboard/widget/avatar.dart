import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final UserType userType;
  final String? userImageUrl;
  final bool loading;
  final GestureTapCallback? onPressed;
  final size = 60.0;
  final smallSize = 40.0;
  final avatarUserRadius = 20.0;
  final avatarEditionRadius = 17.0;
  final progressStrokeWidth = 3.0;
  const AppAvatar({
    Key? key,
    required this.userType,
    this.loading = false,
    this.userImageUrl,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType == UserType.other) {
      return IconButton(
        iconSize: smallSize,
        icon: _getUserIcon(
          context,
          loading,
          userImageUrl,
        ),
        onPressed: onPressed,
      );
    }

    return IconButton(
      iconSize: size,
      splashRadius: smallSize,
      onPressed: onPressed,
      icon: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: size,
              height: size,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: _getUserIcon(
                context,
                loading,
                userImageUrl,
              ),
            ),
            if (userType != UserType.other)
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: avatarEditionRadius,
                  backgroundColor: Colors.transparent,
                  child: _getEditionImage(userType),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _getUserIcon(context, loading, userImageUrl) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final actionColor = colorSchemeExtension.action;

    return Stack(
      children: [
        CircleAvatar(
          radius: avatarUserRadius,
          backgroundColor: Colors.grey[400],
          backgroundImage:
              userImageUrl != null ? NetworkImage(userImageUrl) : null,
          child: userImageUrl == null
              ? Icon(
                  Icons.person,
                  color: actionColor,
                )
              : Container(),
        ),
        if (loading)
          SizedBox(
            height: smallSize,
            width: smallSize,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
              strokeWidth: progressStrokeWidth,
            ),
          ),
      ],
    );
  }

  _getEditionImage(UserType userType) {
    if (userType == UserType.fiab) {
      return Image.asset('assets/images/fiab_edition_logo.png');
    }

    if (userType == UserType.mondora) {
      return Image.asset('assets/images/mondora_edition_logo.png');
    }
  }
}
