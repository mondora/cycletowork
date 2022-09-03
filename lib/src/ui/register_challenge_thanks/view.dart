import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterChallengThanksView extends StatelessWidget {
  const RegisterChallengThanksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var isCyclist = viewModel.uiState.challengeRegistry.isCyclist;

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/register_challenge_thanks.png',
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0),
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
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
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
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: Text(
                'Se lo desideri puoi compilare un breve sondaggio che ci aiuterà a capire qualcosa in più su di te e sul tuo stile ciclistico',
                style: textTheme.caption!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 210.0,
              height: 36.0,
              child: ElevatedButton(
                onPressed: viewModel.gotoSurvey,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    colorScheme.secondary,
                  ),
                ),
                child: Text(
                  'Compila il sondaggio'.toUpperCase(),
                  style: textTheme.button!.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 210.0,
              height: 36.0,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  'Inizia a pedalare'.toUpperCase(),
                  style: textTheme.button!.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
