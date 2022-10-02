import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterChallengThanksView extends StatelessWidget {
  const RegisterChallengThanksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final viewModel = Provider.of<ViewModel>(context);
    var isCyclist = viewModel.uiState.challengeRegistry.isCyclist;

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/register_challenge_thanks.png',
                      fit: BoxFit.cover,
                      // height: (MediaQuery.of(context).size.height / 3) * 1.7,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 40.0 * scale),
                        child: Text(
                          'Grazie!'.toUpperCase(),
                          style: textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isCyclist)
                  Container(
                    margin: EdgeInsets.only(
                      left: 30.0 * scale,
                      right: 30.0 * scale,
                      top: 20.0 * scale,
                    ),
                    child: Text(
                      'L’azienda che hai appena registrato deve essere validata dal nostro team. Ti contatteremo presto via email.',
                      style: textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30.0 * scale,
                    right: 30.0 * scale,
                    top: 20.0 * scale,
                  ),
                  child: Text(
                    'Se lo desideri puoi compilare un breve sondaggio che ci aiuterà a capire qualcosa in più su di te e sul tuo stile ciclistico',
                    style: textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  height: 40 * scale,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: 250.0 * scale,
                    height: 36.0 * scale,
                    child: ElevatedButton(
                      onPressed: viewModel.gotoSurvey,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          colorScheme.secondary,
                        ),
                      ),
                      child: AutoSizeText(
                        'Compila il sondaggio'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20 * scale,
                  ),
                  SizedBox(
                    width: 250.0 * scale,
                    height: 36.0 * scale,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      child: AutoSizeText(
                        'Inizia a pedalare'.toUpperCase(),
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
          ],
        ),
      ),
    );
  }
}
