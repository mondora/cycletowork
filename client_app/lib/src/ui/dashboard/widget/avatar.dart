import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppAvatar extends StatelessWidget {
  final UserType userType;
  final String? userImageUrl;
  final bool loading;
  final GestureTapCallback? onPressed;
  final double size;
  final double smallSize;
  final double avatarUserRadius;
  final double avatarEditionRadius;
  final double progressStrokeWidth;
  final bool visible;
  final bool isAdmin;

  const AppAvatar({
    Key? key,
    required this.userType,
    this.loading = false,
    this.userImageUrl,
    required this.onPressed,
    this.size = 60.0,
    this.smallSize = 40.0,
    this.avatarUserRadius = 20.0,
    this.avatarEditionRadius = 17.0,
    this.progressStrokeWidth = 3.0,
    required this.visible,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    if (!visible) {
      return Container();
    }

    if (userType == UserType.other || isAdmin) {
      return IconButton(
        iconSize: smallSize * scale,
        splashRadius: smallSize * scale,
        icon: _getUserIcon(
          context,
          loading,
          userImageUrl,
          scale,
        ),
        onPressed: onPressed,
      );
    }

    return IconButton(
      iconSize: size * scale,
      splashRadius: smallSize * scale,
      onPressed: onPressed,
      icon: SizedBox(
        width: size * scale,
        height: size * scale,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: size * scale,
              height: size * scale,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: _getUserIcon(context, loading, userImageUrl, scale),
            ),
            if (userType != UserType.other)
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: avatarEditionRadius * scale,
                  backgroundColor: Colors.transparent,
                  child: _getEditionImage(userType),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _getUserIcon(context, loading, userImageUrl, scale) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final actionColor = colorSchemeExtension.action;
    final colorScheme = Theme.of(context).colorScheme;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;

    return Stack(
      children: [
        CircleAvatar(
          radius: avatarUserRadius * scale,
          backgroundColor: Colors.grey[400],
          backgroundImage:
              userImageUrl != null ? NetworkImage(userImageUrl) : null,
          child: userImageUrl == null
              ? Icon(
                  isAdmin ? Icons.admin_panel_settings : Icons.person,
                  color: actionColor,
                )
              : Container(),
        ),
        if (loading)
          SizedBox(
            height: smallSize * scale,
            width: smallSize * scale,
            child: CircularProgressIndicator(
              color: color,
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
