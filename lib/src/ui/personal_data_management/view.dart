import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalDataManagementView extends StatelessWidget {
  const PersonalDataManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Gestione dati personali',
          style: textTheme.bodyText1,
        ),
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Cancellare i dati',
              style: textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
              // maxLines: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            // Text(
            //   'Per cancellare tutti i dati personali contenuti in questo servizio mandate una email a info@mondora.com con oggetto “Richiesta di cancellazione di tutti i dati personali su Cycle2Work”. La cancellazione dei dati sarà definitiva e i dati non potranno più essere recuperati.',
            //   style: textTheme.bodyText2!.copyWith(
            //     fontWeight: FontWeight.w400,
            //   ),
            //   maxLines: 20,
            // ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.w400),
                    text:
                        'Per cancellare tutti i dati personali contenuti in questo servizio mandate una email a ',
                  ),
                  TextSpan(
                    style: textTheme.bodyText2!.copyWith(
                      decoration: TextDecoration.underline,
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                    text: 'info@mondora.com ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'info@mondora.com',
                          query: encodeQueryParameters(<String, String>{
                            'subject':
                                'Richiesta di cancellazione di tutti i dati personali su Cycle2Work',
                          }),
                        );
                        await launchUrl(
                          emailLaunchUri,
                        );
                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(
                            emailLaunchUri,
                          );
                        }
                      },
                  ),
                  TextSpan(
                    style: textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.w400),
                    text:
                        'con oggetto “Richiesta di cancellazione di tutti i dati personali su Cycle2Work”. La cancellazione dei dati sarà definitiva e i dati non potranno più essere recuperati.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
