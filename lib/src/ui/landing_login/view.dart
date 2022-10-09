import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
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
    final scale = context.read<AppData>().scale;
    final isHuaweiDevice = context.read<AppData>().isHuaweiDevice;
    final landingModel = Provider.of<ViewModel>(context);
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final colorScheme = Theme.of(context).colorScheme;

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
              margin: EdgeInsets.symmetric(
                horizontal: 25.0 * scale,
              ),
              child: Stack(
                children: [
                  if (loading == true)
                    Align(
                      alignment: FractionalOffset.center,
                      child: AppProgressIndicator(
                        color: colorScheme.secondary,
                      ),
                    ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0 * scale),
                        child: Text(
                          'Hai già un account?'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption!.apply(
                                color: colorScheme.onPrimary,
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10.0 * scale,
                        ),
                        child: AppButton(
                          loading: loading,
                          onPressed: () => landingModel.gotoLoginEmail(),
                          title: AppLocalizations.of(context)!.login,
                          textUpperCase: true,
                          type: ButtonType.secondary,
                          maxWidth: 95 * scale,
                          radius: 8.0 * scale,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24.0 * scale),
                        child: Text(
                          'Oppure:'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption!.apply(
                                color: colorScheme.onPrimary,
                              ),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //     top: 10.0*scale,
                      //   ),
                      //   child: AppButton(
                      //     loading: loading,
                      //     onPressed: () {},
                      //     title:
                      //         AppLocalizations.of(context)!.signupWithFacebook,
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
                            onPressed: landingModel.loginGoogleSignIn,
                            title:
                                AppLocalizations.of(context)!.signupWithGoogle,
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
                                onPressed: landingModel.loginApple,
                                title: 'Accedi con Apple',
                                textUpperCase: true,
                                type: ButtonType.appleLogin,
                                radius: 8.0 * scale,
                              ),
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 14.0 * scale,
                        ),
                        child: AppButton(
                          loading: loading,
                          onPressed: () => landingModel.gotoSignupEmail(),
                          title: AppLocalizations.of(context)!.signupWithEmail,
                          textUpperCase: true,
                          type: ButtonType.emailLogin,
                          radius: 8.0 * scale,
                        ),
                      ),
                      SizedBox(
                        height: 20.0 * scale,
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
