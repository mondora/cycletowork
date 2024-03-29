import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/privacy_policy/view.dart';
import 'package:cycletowork/src/widget/button.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:provider/provider.dart';

class SignupEmailView extends StatefulWidget {
  const SignupEmailView({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupEmailView> createState() => _SignupEmailViewState();
}

class _SignupEmailViewState extends State<SignupEmailView> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    final landingModel = Provider.of<ViewModel>(context);
    var loading = landingModel.uiState.loading;
    final colorScheme = Theme.of(context).colorScheme;

    if (loading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Image(
                image: AssetImage(
                  'assets/images/login.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AppProgressIndicator(
                color: colorScheme.secondary,
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: onBackgroundColor,
          ),
          onPressed: () => landingModel.gotoLogout(),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
          child: ListView(
            physics: const ScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0 * scale),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.signupWithEmail,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0 * scale),
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
                margin: EdgeInsets.only(top: 30.0 * scale),
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
                margin: EdgeInsets.only(top: 30.0 * scale),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Password*',
                    helperText: 'La password deve contenere almeno 8 caratteri',
                    hintMaxLines: 2,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire password';
                    }
                    if (value.length < 8) {
                      return 'La password deve contenere almeno 8 caratteri';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0 * scale),
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
                margin: EdgeInsets.only(top: 26.0 * scale),
                child: Text(
                  '(*) Campi obbligatori',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0 * scale),
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
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyView(),
                              ),
                            );
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
                margin: EdgeInsets.only(top: 20.0 * scale),
                child: AppButton(
                  title: AppLocalizations.of(context)!.login,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var email = emailController.text.toLowerCase().trim();
                      var password = passwordController.text;
                      var name = nameController.text;
                      await landingModel.signupEmail(email, password, name);
                    }
                  },
                  type: ButtonType.secondary,
                  maxWidth: 95 * scale,
                  horizontalMargin: 0.0,
                  radius: 8.0 * scale,
                ),
              ),
              SizedBox(
                height: 20.0 * scale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
