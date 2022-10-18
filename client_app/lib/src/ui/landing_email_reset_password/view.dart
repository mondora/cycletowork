import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:provider/provider.dart';

class LoginEmailResetPasswordView extends StatelessWidget {
  final ViewModel landingModel;

  const LoginEmailResetPasswordView({
    Key? key,
    required this.landingModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();

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
          margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
          child: ListView(
            physics: const ScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0 * scale),
                child: Center(
                  child: Text(
                    'Recupera password',
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
                margin: EdgeInsets.only(top: 26.0 * scale),
                child: Text(
                  '(*) Campi obbligatori',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0 * scale),
                child: AppButton(
                  title: 'recupera password',
                  textUpperCase: true,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var email = emailController.text.toLowerCase().trim();
                      var result = await landingModel.passwordReset(email);
                      if (result == true) {
                        await AppAlartDialog(
                          context: context,
                          title: 'Attenzione!',
                          subtitle:
                              '''Abbiamo mandato un email a "$email" con un link per cambiare password.''',
                          body: '',
                          confirmLabel: 'Ho capito',
                        ).show();
                        Navigator.pop(context);
                      }
                    }
                  },
                  type: ButtonType.secondary,
                  maxWidth: 95 * scale,
                  horizontalMargin: 0.0,
                  radius: 8.0 * scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
