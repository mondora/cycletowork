import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/landing_email_reset_password/view.dart';
import 'package:cycletowork/src/widget/button.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:provider/provider.dart';

class LoginEmailView extends StatefulWidget {
  const LoginEmailView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginEmailView> createState() => _LoginEmailViewState();
}

class _LoginEmailViewState extends State<LoginEmailView> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final isHuaweiDevice = context.read<AppData>().isHuaweiDevice;
    final landingModel = Provider.of<ViewModel>(context);
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    final formKey = GlobalKey<FormState>();

    final loading = landingModel.uiState.loading;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
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
                    'Accedi con l’indirizzo email',
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
                margin: EdgeInsets.only(top: 26.0 * scale),
                child: Text(
                  '(*) Campi obbligatori',
                  style: Theme.of(context).textTheme.caption,
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

                      await landingModel.loginEmail(email, password);
                    }
                  },
                  type: ButtonType.secondary,
                  maxWidth: 95 * scale,
                  horizontalMargin: 0.0,
                  radius: 8.0 * scale,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0 * scale),
                child: AppButton(
                  title: 'HAI DIMENTICATO LA PASSWORD?',
                  textUpperCase: true,
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginEmailResetPasswordView(
                          landingModel: landingModel,
                        ),
                      ),
                    );
                  },
                  type: ButtonType.text,
                  maxWidth: 95 * scale,
                  horizontalMargin: 0.0,
                  radius: 8.0 * scale,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24.0 * scale),
                child: Text(
                  'Oppure',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              // Container(
              //   margin:  EdgeInsets.only(
              //     top: 10.0*scale,
              //   ),
              //   child: AppButton(
              //     loading: loading,
              //     onPressed: () {},
              //     title: 'Accedi con Facebook',
              //     textUpperCase: true,
              //     type: ButtonType.facebookLogin,
              //     radius: 8.0*scale,
              //   ),
              // ),
              if (!isHuaweiDevice)
                Container(
                  margin: EdgeInsets.only(
                    top: 14.0 * scale,
                  ),
                  child: AppButton(
                    loading: loading,
                    onPressed: () => landingModel.loginGoogleSignIn(),
                    title: 'Accedi con Google',
                    textUpperCase: true,
                    type: ButtonType.googleLogin,
                    radius: 8.0 * scale,
                  ),
                ),
              isIos
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 14.0 * scale,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () => landingModel.loginApple(),
                        title: 'Accedi con Apple',
                        textUpperCase: true,
                        type: ButtonType.appleLogin,
                        radius: 8.0 * scale,
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
