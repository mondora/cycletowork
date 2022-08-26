import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/widget/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLoginView extends StatelessWidget {
  final bool loading;
  const AdminLoginView({
    Key? key,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<ViewModel>(context);
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            if (loading == true)
              const Align(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator(),
              ),
            Center(
              child: Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                  physics: const ScrollPhysics(),
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/admin_login.png',
                      ),
                      fit: BoxFit.cover,
                    ),
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
                          helperText:
                              'La password deve contenere almeno 8 caratteri, almeno uno maiuscolo, almeno un numero',
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
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            var email = emailController.text;
                            var password = passwordController.text;
                            landingModel.loginEmail(email, password);
                          }
                        },
                        type: ButtonType.secondary,
                        maxWidth: 95,
                        horizontalMargin: 0.0,
                        radius: 8.0,
                        loading: loading,
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
