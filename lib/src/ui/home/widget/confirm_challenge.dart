import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmChallengeDialog {
  final BuildContext context;
  final BorderRadius borderRadius;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String confirmButton;
  final TextStyle? confirmButtonStyle;
  final String cancelButton;
  final TextStyle? cancelButtonStyle;

  ConfirmChallengeDialog({
    required this.context,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(10),
    ),
    this.contentStyle,
    this.titleStyle,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
    required this.title,
    required this.confirmButton,
    required this.cancelButton,
  });

  Future<bool?> show() async {
    var scale = context.read<AppData>().scale;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        var colorScheme = Theme.of(context).colorScheme;
        var textTheme = Theme.of(context).textTheme;
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              insetPadding: EdgeInsets.all(25 * scale),
              backgroundColor: colorScheme.primary,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 320.0 * scale,
                    maxWidth: 350.0 * scale,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10 * scale),
                        child: Image.asset(
                          'assets/images/confirm_challenge.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Text(
                        'Iscriviti alla',
                        style: textTheme.bodyText1!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 9 * scale,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0 * scale),
                        child: Text(
                          title,
                          style: textTheme.headline6!.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20 * scale,
                      ),
                      Text(
                        'di FIAB',
                        style: textTheme.subtitle1!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 40 * scale,
                      ),
                      SizedBox(
                        width: 210.0 * scale,
                        height: 36.0 * scale,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8.0 * scale),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              colorScheme.secondary,
                            ),
                          ),
                          child: AutoSizeText(
                            confirmButton,
                            style: textTheme.button!.copyWith(
                              color: colorScheme.onSecondary,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 17 * scale,
                      ),
                      SizedBox(
                        width: 210.0 * scale,
                        height: 36.0 * scale,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8.0 * scale),
                                side: BorderSide(
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                          child: AutoSizeText(
                            cancelButton,
                            style: textTheme.button!.copyWith(
                              color: colorScheme.secondary,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30 * scale,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
