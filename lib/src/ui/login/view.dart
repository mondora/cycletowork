import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/ui/signup/view.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:cycletowork/src/widget/button.dart';

class LoginView extends StatelessWidget {
  final bool loading;
  const LoginView({
    Key? key,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<LandingViewModel>(context);
    // final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const Image(
            image: AssetImage(
              'assets/images/login.png',
            ),
            fit: BoxFit.cover,
          ),
          Stack(
            children: [
              if (loading == true)
                const Align(
                  alignment: FractionalOffset.center,
                  child: AppProgressIndicator(),
                ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        AppLocalizations.of(context)!.iHaveAlreadyAnAccount,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () {
                          landingModel.loginEmail("email", "password", "name");
                        },
                        title: AppLocalizations.of(context)!.login,
                        textUpperCase: true,
                        type: ButtonType.secondary,
                        maxWidth: 95,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24.0),
                      child: Text(
                        AppLocalizations.of(context)!.createANewAccount,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () {},
                        title: AppLocalizations.of(context)!.signupWithFacebook,
                        textUpperCase: true,
                        type: ButtonType.facebookLogin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 14.0,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () {},
                        title: AppLocalizations.of(context)!.signupWithGoogle,
                        textUpperCase: true,
                        type: ButtonType.googleLogin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 14.0,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () {},
                        title: AppLocalizations.of(context)!.signupWithApple,
                        textUpperCase: true,
                        type: ButtonType.appleLogin,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 14.0,
                      ),
                      child: AppButton(
                        loading: loading,
                        onPressed: () {
                          // landingModel.signupEmail();
                          // Navigator.pushNamed(
                          //   context,
                          //   SignupView.routeName,
                          // );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignupView(),
                            ),
                          );
                        },
                        title: AppLocalizations.of(context)!.signupWithEmail,
                        textUpperCase: true,
                        type: ButtonType.emailLogin,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyModel {
  static instance() {}
}
