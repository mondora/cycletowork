import 'package:flutter/material.dart';

class ClassificationView extends StatelessWidget {
  const ClassificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Classifica',
              style: textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            height: (MediaQuery.of(context).size.height / 3) * 2,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.only(left: 23.0, right: 19.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Text(
                'La classifica è disponibile soltanto se partecipi a una challenge.',
                style: textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
