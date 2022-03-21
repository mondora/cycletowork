import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cycle To Work'),
    );
  }
}
