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
    final viewModel = Provider.of<ViewModel>(context);
    final businessEmail = viewModel.uiState.challengeRegistry.businessEmail;
    final emailIsVerified =
        viewModel.uiState.challengeRegistry.businessEmailVerification;
    final isCyclist = viewModel.uiState.challengeRegistry.isCyclist;

    final colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(
          top: 20.0,
          bottom: 30.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 30.0,
                    left: 30.0,
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
                  margin: const EdgeInsets.only(
                    right: 30.0,
                    left: 30.0,
                  ),
                  child: Text(
                    businessEmail,
                    style: textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 155.0,
                  height: 36.0,
                  child: TextButton(
                    onPressed: !emailIsVerified
                        ? viewModel.sendEmailVerificationCode
                        : null,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        colorScheme.onSecondary,
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        colorScheme.secondary.withOpacity(0.40),
                      ),
                    ),
                    child: Text(
                      'Invia di nuovo'.toUpperCase(),
                      style: textTheme.button!.copyWith(
                        color: !emailIsVerified
                            ? colorScheme.secondary
                            : colorSchemeExtension.textDisabled
                                .withOpacity(0.12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(
                    right: 30.0,
                    left: 30.0,
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
                          borderColor: colorScheme.secondary,
                          cursorColor: colorScheme.secondary,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          enabledBorderColor:
                              const Color.fromRGBO(242, 242, 242, 1),
                          focusedBorderColor: colorScheme.secondary,
                          filled: true,
                          showFieldAsBox: true,
                          onSubmit: (code) => viewModel.verifiyEmailCode(code),
                        ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 30.0,
                    left: 30.0,
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
                  margin: const EdgeInsets.only(
                    right: 30.0,
                    left: 30.0,
                  ),
                  child: Text(
                    'Controlla anche che la nostra email non sia finita nella posta indesiderata.',
                    style: textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Center(
                  child: SizedBox(
                    width: 155.0,
                    height: 36.0,
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
                      child: Text(
                        'Prosegui'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: emailIsVerified
                              ? colorScheme.onSecondary
                              : colorSchemeExtension.textDisabled,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: SizedBox(
                    width: 155.0,
                    height: 36.0,
                    child: OutlinedButton(
                      onPressed: isCyclist
                          ? viewModel.gotoCyclistRegistrationData
                          : viewModel.gotoChampionRegistrationData,
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
                      child: Text(
                        'Torna indietro'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: !emailIsVerified
                              ? colorScheme.secondary
                              : colorSchemeExtension.textDisabled,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
