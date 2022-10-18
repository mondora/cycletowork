import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

class RegisterChallengEmailVerifyView extends StatefulWidget {
  const RegisterChallengEmailVerifyView({Key? key}) : super(key: key);

  @override
  State<RegisterChallengEmailVerifyView> createState() =>
      _RegisterChallengEmailVerifyViewState();
}

class _RegisterChallengEmailVerifyViewState
    extends State<RegisterChallengEmailVerifyView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final viewModel = Provider.of<ViewModel>(context);
    final businessEmail = viewModel.uiState.challengeRegistry.businessEmail;
    final emailIsVerified =
        viewModel.uiState.challengeRegistry.businessEmailVerification;
    final isCyclist = viewModel.uiState.challengeRegistry.isCyclist;

    final colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;
    final backgroundColor = colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(239, 239, 239, 1)
        : Colors.grey[800];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => !emailIsVerified
              ? isCyclist
                  ? viewModel.gotoCyclistRegistrationData()
                  : viewModel.gotoChampionRegistrationData()
              : null,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.0 * scale,
            bottom: 30.0 * scale,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 30.0 * scale,
                    left: 30.0 * scale,
                  ),
                  child: Text(
                    'Ti abbiamo inviato una email di verifica all’indirizzo',
                    style: textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 30.0 * scale,
                    left: 30.0 * scale,
                  ),
                  child: Text(
                    businessEmail,
                    style: textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0 * scale,
                ),
                SizedBox(
                  width: 165.0 * scale,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16.0 * scale),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0 * scale),
                        ),
                      ),
                      foregroundColor: colorScheme.secondary,
                    ),
                    onPressed: !emailIsVerified
                        ? viewModel.sendEmailVerificationCode
                        : null,
                    child: Text(
                      'Invia di nuovo'.toUpperCase(),
                      style: textTheme.caption!.copyWith(
                        color: !emailIsVerified
                            ? colorScheme.secondary
                            : colorSchemeExtension.textDisabled
                                .withOpacity(0.40),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  height: 150 * scale,
                  margin: EdgeInsets.only(
                    right: 30.0 * scale,
                    left: 30.0 * scale,
                  ),
                  child: emailIsVerified
                      ? Center(
                          child: Text(
                            'Grazie per aver confermato il tuo indirizzo email',
                            style: textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorSchemeExtension.success,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : OtpTextField(
                          numberOfFields: 6,
                          borderColor: color,
                          cursorColor: color,
                          fillColor: backgroundColor!,
                          enabledBorderColor: backgroundColor,
                          focusedBorderColor: color,
                          filled: true,
                          showFieldAsBox: true,
                          onSubmit: (code) => viewModel.verifiyEmailCode(code),
                        ),
                ),
                SizedBox(
                  height: 40 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 30.0 * scale,
                    left: 30.0 * scale,
                  ),
                  child: Text(
                    'Se non hai ricevuto nessuna email, verifica la correttezza dell’indirizzo che hai fornito e nel caso sia errato torna indietro a correggerlo.',
                    style: textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 30.0 * scale,
                    left: 30.0 * scale,
                  ),
                  child: Text(
                    'Controlla anche che la nostra email non sia finita nella posta indesiderata.',
                    style: textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40.0 * scale,
                ),
                Center(
                  child: SizedBox(
                    width: 165.0 * scale,
                    height: 36.0 * scale,
                    child: ElevatedButton(
                      onPressed:
                          emailIsVerified ? viewModel.registerChallenge : null,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          emailIsVerified
                              ? colorScheme.secondary
                              : colorSchemeExtension.textDisabled
                                  .withOpacity(0.12),
                        ),
                      ),
                      child: AutoSizeText(
                        'Prosegui'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: emailIsVerified
                              ? colorScheme.onSecondary
                              : colorSchemeExtension.textDisabled,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0 * scale,
                ),
                Center(
                  child: SizedBox(
                    width: 155.0 * scale,
                    height: 36.0 * scale,
                    child: OutlinedButton(
                      onPressed: !emailIsVerified
                          ? isCyclist
                              ? viewModel.gotoCyclistRegistrationData
                              : viewModel.gotoChampionRegistrationData
                          : null,
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
                        backgroundColor: MaterialStateProperty.all<Color>(
                          !emailIsVerified
                              ? colorScheme.onSecondary
                              : colorSchemeExtension.textDisabled
                                  .withOpacity(0.12),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          colorScheme.secondary.withOpacity(0.40),
                        ),
                      ),
                      child: AutoSizeText(
                        'Torna indietro'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: !emailIsVerified
                              ? colorScheme.secondary
                              : colorSchemeExtension.textDisabled,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0 * scale,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
