import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/ui/login_email/view.dart';
import 'package:cycletowork/src/ui/signup/view.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:cycletowork/src/widget/button.dart';

class LoginView extends StatelessWidget {
  final bool loading;
  const LoginView({
    Key? key,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<ViewModel>(context);
    var isIos = defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Image(
              image: AssetImage(
                'assets/images/login.png',
              ),
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Stack(
                children: [
                  if (loading == true)
                    const Align(
                      alignment: FractionalOffset.center,
                      child: AppProgressIndicator(),
                    ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Hai già un account?'.toUpperCase(),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginEmailView(
                                  landingModel: landingModel,
                                ),
                              ),
                            );
                          },
                          title: AppLocalizations.of(context)!.login,
                          textUpperCase: true,
                          type: ButtonType.secondary,
                          maxWidth: 95,
                          radius: 8.0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        child: Text(
                          'Oppure:'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(
                      //     top: 10.0,
                      //   ),
                      //   child: AppButton(
                      //     loading: loading,
                      //     onPressed: () {},
                      //     title:
                      //         AppLocalizations.of(context)!.signupWithFacebook,
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
                          onPressed: landingModel.loginGoogleSignIn,
                          title: AppLocalizations.of(context)!.signupWithGoogle,
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
                                onPressed: landingModel.loginApple,
                                title: 'Accedi con Apple',
                                textUpperCase: true,
                                type: ButtonType.appleLogin,
                                radius: 8.0,
                              ),
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 14.0,
                        ),
                        child: AppButton(
                          loading: loading,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignupView(
                                  landingModel: landingModel,
                                ),
                              ),
                            );
                          },
                          title: AppLocalizations.of(context)!.signupWithEmail,
                          textUpperCase: true,
                          type: ButtonType.emailLogin,
                          radius: 8.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
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
