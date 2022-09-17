import 'package:cycletowork/src/ui/profile_delete_account/view.dart';
import 'package:flutter/material.dart';

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
          'Cancellare Account',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Cancellare i dati',
                  style: textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Attenzione!',
                  style: textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'La cancellazione dei dati sarà definitiva e i dati non potranno più essere recuperati.',
                  style: textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    foregroundColor: colorScheme.secondary,
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileDeleteAccountView(),
                      ),
                    );
                  },
                  child: Text(
                    'Cancella Account',
                    style: textTheme.caption!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
