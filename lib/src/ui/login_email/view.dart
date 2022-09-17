import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class LoginEmailView extends StatelessWidget {
  final ViewModel landingModel;

  const LoginEmailView({
    Key? key,
    required this.landingModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var loading = landingModel.uiState.pageOption == PageOption.loading;
    var isIos = defaultTargetPlatform == TargetPlatform.iOS;

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
            physics: const ScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Text(
                    'Accedi con l’indirizzo email',
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire password';
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
                margin: const EdgeInsets.only(top: 20.0),
                child: AppButton(
                  title: AppLocalizations.of(context)!.login,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var email = emailController.text;
                      var password = passwordController.text;
                      var result =
                          await landingModel.loginEmail(email, password);
                      if (result) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  type: ButtonType.secondary,
                  maxWidth: 95,
                  horizontalMargin: 0.0,
                  radius: 8.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24.0),
                child: Text(
                  'Oppure',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(
              //     top: 10.0,
              //   ),
              //   child: AppButton(
              //     loading: loading,
              //     onPressed: () {},
              //     title: 'Accedi con Facebook',
              //     textUpperCase: true,
              //     type: ButtonType.facebookLogin,
              //     radius: 8.0,
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.only(
                  top: 14.0,
                ),
                child: AppButton(
                  loading: loading,
                  onPressed: () {
                    landingModel.loginGoogleSignIn();
                    Navigator.pop(context);
                  },
                  title: 'Accedi con Google',
                  textUpperCase: true,
                  type: ButtonType.googleLogin,
                  radius: 8.0,
                ),
              ),
              isIos
                  ? Container(
                      margin: const EdgeInsets.only(
                        top: 14.0,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () {
                          landingModel.loginApple();
                          Navigator.pop(context);
                        },
                        title: 'Accedi con Apple',
                        textUpperCase: true,
                        type: ButtonType.appleLogin,
                        radius: 8.0,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
