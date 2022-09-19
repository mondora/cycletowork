import 'package:cycletowork/src/data/app_data.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SliderButton extends StatelessWidget {
  final Widget rightWidget;
  final Widget leftWidget;
  final Color baseColor;
  final Color buttonColor;
  final Color highlightedColor;
  final Function(DismissDirection)? onDismissed;
  final Key dismissKey;

  const SliderButton({
    Key? key,
    required this.rightWidget,
    required this.leftWidget,
    this.baseColor = Colors.black87,
    this.buttonColor = Colors.white,
    this.highlightedColor = Colors.white,
    required this.onDismissed,
    required this.dismissKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    return Container(
      height: 54.0 * scale,
      margin: EdgeInsets.symmetric(horizontal: 27.0 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          width: 1.0,
          color: const Color.fromRGBO(0, 0, 0, 0.12),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0.0, 2.0),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            inset: true,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 13.0 * scale),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightedColor,
                direction: ShimmerDirection.rtl,
                child: leftWidget,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(right: 13.0 * scale),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightedColor,
                direction: ShimmerDirection.ltr,
                child: rightWidget,
              ),
            ),
          ),
          Dismissible(
            dismissThresholds: const {
              DismissDirection.startToEnd: 0.35,
              DismissDirection.endToStart: 0.35,
            },
            key: dismissKey,
            onDismissed: onDismissed,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
