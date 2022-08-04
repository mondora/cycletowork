import 'package:cycletowork/src/widget/button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupEmailView extends StatelessWidget {
  const SignupEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<LandingViewModel>(context);
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var rePasswordController = TextEditingController();

    RegExp regExpNumber = RegExp(r'^(?=.*\d)[a-zA-Z\d]');
    RegExp regExpLowerCase = RegExp(r'^(?=.*[a-z])');
    RegExp regExpUpperCase = RegExp(r'^(?=.*[A-Z])');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: onBackgroundColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.signupWithEmail,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nick name',
                  ),
                  controller: nameController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email*',
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Inserire un email valido';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Password*',
                    helperText:
                        'La password deve contenere almeno 8 caratteri, almeno uno maiuscolo, almeno un numero',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire password';
                    }
                    if (value.length < 8) {
                      return 'La password deve contenere almeno 8 caratteri';
                    }
                    if (!regExpNumber.hasMatch(value)) {
                      return 'La password deve contenere almeno un numero';
                    }
                    if (!regExpLowerCase.hasMatch(value)) {
                      return 'La password deve contenere almeno uno minuscolo';
                    }
                    if (!regExpUpperCase.hasMatch(value)) {
                      return 'La password deve contenere almeno uno maiuscolo';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: rePasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Ripeti la password*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire password';
                    }
                    if (value != passwordController.text) {
                      return 'Inserire password uguale';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 26.0),
                child: Text(
                  '(*) Campi obbligatori',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        text: 'Effettuando l’iscrizione dichiari di accettare ',
                      ),
                      TextSpan(
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                        text: 'l’informativa sulla privacy',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = Uri.parse(
                                'https://www.sataspes.net/android/sp-budget');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                // mode: LaunchMode.inAppWebView,
                              );
                            }
                          },
                      ),
                      TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        text: ' di Clicle2Work.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: AppButton(
                  title: AppLocalizations.of(context)!.login,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var email = emailController.text;
                      var password = passwordController.text;
                      var name = nameController.text;
                      landingModel.loginEmail(email, password, name);
                    }
                  },
                  type: ButtonType.secondary,
                  maxWidth: 95,
                  horizontalMargin: 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
