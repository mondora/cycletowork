import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RegisterChallengSelectTypeView extends StatelessWidget {
  const RegisterChallengSelectTypeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var challengeName = viewModel.uiState.challenge!.name;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            right: 35.0,
            left: 35.0,
            bottom: 30.0,
          ),
          child: Column(
            children: [
              Text(
                'Iscriviti alla',
                style: textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                challengeName.toUpperCase(),
                style: textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 26.0,
              ),
              SvgPicture.asset(
                'assets/icons/biking.svg',
                height: 75,
                width: 75,
              ),
              const SizedBox(
                height: 29.0,
              ),
              Text(
                'Come ciclista, potrai sempre tracciare le tue attività personali. Se vuoi partecipare alla Bike Challenge e vedere le classifiche, seleziona la tua azienda nella prossima schermata.',
                style: textTheme.caption!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
                maxLines: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250.0,
                height: 36.0,
                child: ElevatedButton(
                  onPressed: viewModel.gotoCyclistRegistration,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ISCRIVITI come ciclista'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_outlined,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              const SizedBox(
                height: 30.0,
              ),
              SvgPicture.asset(
                'assets/icons/group_biking.svg',
                height: 80,
                width: 483,
              ),
              const SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Registra la tua azienda alla Bike Challenge e diventane il champion. Sarai il punto di riferimento per tutti i tuoi colleghi.',
                      style: textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    WidgetSpan(
                      child: Container(
                        margin: const EdgeInsets.only(left: 4.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Icon(
                                Icons.info,
                                size: 15,
                                color: colorSchemeExtension.info,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 250.0,
                height: 36.0,
                child: ElevatedButton(
                  onPressed: viewModel.gotoChampionRegistration,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ISCRIVI la tua azienda'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
