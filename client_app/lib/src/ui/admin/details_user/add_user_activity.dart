import 'package:cycletowork/src/data/user_activity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cycletowork/src/utility/convert.dart';

class AddUserActivityDialog {
  final BuildContext context;
  final BorderRadius borderRadius;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String confirmButton;
  final TextStyle? confirmButtonStyle;
  final String cancelButton;
  final TextStyle? cancelButtonStyle;
  final String uid;

  var formKey = GlobalKey<FormState>();
  var distanceController = TextEditingController();
  var challengeIdController = TextEditingController();
  var companyIdController = TextEditingController();

  UserActivity? newUserActivity;

  AddUserActivityDialog({
    required this.context,
    required this.uid,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8.0),
    ),
    this.contentStyle,
    this.title = 'Inserire nuova azienda',
    this.titleStyle,
    this.confirmButton = 'AGGIUNGI',
    this.confirmButtonStyle,
    this.cancelButton = 'ANNULLA',
    this.cancelButtonStyle,
  });

  Future<UserActivity?> show() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900.0,
                  ),
                  child: Form(
                    key: formKey,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Dati generali di attività",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 15,
                                keyboardType: TextInputType.number,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.digitsOnly,
                                // ],
                                textInputAction: TextInputAction.next,
                                controller: distanceController,
                                decoration: const InputDecoration(
                                  labelText: 'Distanza (metri)',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire distanza in metri';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: challengeIdController,
                                decoration: const InputDecoration(
                                  labelText: 'Challenge Id',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire challenge Id';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: companyIdController,
                                decoration: const InputDecoration(
                                  labelText: 'Id Azienda',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire Id azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                        bottom: 20),
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('ANNULLA'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                        bottom: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          double distance = double.parse(
                                              distanceController.text.trim());
                                          var challengeId =
                                              challengeIdController.text.trim();
                                          var companyId =
                                              companyIdController.text.trim();

                                          var now = DateTime.now();
                                          var startTime =
                                              now.millisecondsSinceEpoch;
                                          var stopTime = now
                                              .add(const Duration(minutes: 60))
                                              .millisecondsSinceEpoch;
                                          var duration =
                                              const Duration(minutes: 60)
                                                  .inSeconds;
                                          newUserActivity = UserActivity(
                                            uid: uid,
                                            userActivityId: const Uuid().v4(),
                                            startTime: startTime,
                                            stopTime: stopTime,
                                            duration: duration,
                                            distance: distance,
                                            co2: distance
                                                .distanceInMeterToCo2g(),
                                            steps: distance
                                                .distanceInMeterToSteps()
                                                .toInt(),
                                            calorie: distance
                                                .toCalorieFromDistanceInMeter(),
                                            averageSpeed: 2.5,
                                            maxSpeed: 2.5,
                                            isChallenge: 1,
                                            isUploaded: 1,
                                            isSendedToReview: 0,
                                            maxAccuracy: 0,
                                            minAccuracy: 0,
                                            city: '',
                                            challengeId: challengeId,
                                            companyId: companyId,
                                          );

                                          Navigator.of(context)
                                              .pop(newUserActivity);
                                        }
                                      },
                                      child: const Text("SALVA"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
