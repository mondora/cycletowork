import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.read<AppData>();
    var scale = appData.scale;
    var isWakelockModeEnable = context.watch<AppData>().isWakelockModeEnable;
    var themeMode = context.watch<AppData>().themeMode;
    var measurementUnit = context.watch<AppData>().measurementUnit;
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final listThemeMode = [
      'Light',
      'Dark',
      'Automatico',
    ];
    final listMeasurementUnit = [
      'Metriche (Km)',
      'Imperiali (mi)',
    ];

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 10 * scale,
          ),
          Center(
            child: Text(
              'Impostazioni',
              style: textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20 * scale,
          ),
          SizedBox(
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0 * scale),
                child: Text(
                  'Dark mode',
                  style: textTheme.bodyText1,
                ),
              ),
              subtitle: DropdownButtonFormField<String>(
                isExpanded: true,
                hint: Text(
                  'Seleziona dark mode',
                  style: textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorSchemeExtension.textDisabled,
                  ),
                ),
                items: listThemeMode.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: textTheme.caption,
                    ),
                  );
                }).toList(),
                value: listThemeMode.firstWhere(
                  (ele) => ele.toLowerCase() == themeMode.name.toString(),
                  orElse: () => 'Automatico',
                ),
                onChanged: (value) async {
                  if (value != null) {
                    await appData.setThemeMode(value);
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 15 * scale,
          ),
          Container(
            height: 1 * scale,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5 * scale,
          ),
          SizedBox(
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0 * scale),
                child: Text(
                  'Unità di misura',
                  style: textTheme.bodyText1,
                ),
              ),
              subtitle: DropdownButtonFormField<String>(
                isExpanded: true,
                hint: Text(
                  'Seleziona unità di misura',
                  style: textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorSchemeExtension.textDisabled,
                  ),
                ),
                items: listMeasurementUnit.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: textTheme.caption,
                    ),
                  );
                }).toList(),
                value: measurementUnit == AppMeasurementUnit.metric
                    ? 'Metriche (Km)'
                    : 'Imperiali (mi)',
                onChanged: (value) async {
                  if (value != null) {
                    var unit = value == 'Metriche (Km)'
                        ? AppMeasurementUnit.metric
                        : AppMeasurementUnit.imperial;
                    await appData.setMeasurementUnit(unit.name);
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 15 * scale,
          ),
          Container(
            height: 1 * scale,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5 * scale,
          ),
          SizedBox(
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0 * scale),
                child: Text(
                  'Schermo sempre attivo',
                  style: textTheme.bodyText1,
                ),
              ),
              subtitle: Text(
                'Questa opzione, se attiva, impedisce allo schermo di spegnersi durante la registrazione di una pedalata.',
                style: textTheme.caption,
              ),
              trailing: Switch(
                value: isWakelockModeEnable,
                onChanged: (value) async {
                  await appData.setWakelockModeEnable(value);
                },
              ),
            ),
          ),
          SizedBox(
            height: 10 * scale,
          ),
          Container(
            height: 1 * scale,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
