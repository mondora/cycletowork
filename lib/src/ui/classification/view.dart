import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/classification_cyclist/view.dart';
import 'package:cycletowork/src/ui/classification_department/view.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/classification_company/view.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ClassificationView extends StatefulWidget {
  const ClassificationView({Key? key}) : super(key: key);

  @override
  State<ClassificationView> createState() => _ClassificationViewState();
}

class _ClassificationViewState extends State<ClassificationView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    var listChallengeRegistred = viewModel.uiState.listChallengeRegistred;
    var registeredToChalleng = listChallengeRegistred.isNotEmpty;
    List<String> listChallengeName =
        listChallengeRegistred.map((e) => e.challengeName).toList();

    var challengeRegistrySelected = viewModel.uiState.challengeRegistrySelected;
    var userCompanyClassification = viewModel.uiState.userCompanyClassification;
    var userCyclistClassification = viewModel.uiState.userCompanyClassification;
    var userDepartmentClassification =
        viewModel.uiState.userDepartmentClassification;
    var hasDepartment = challengeRegistrySelected != null &&
        challengeRegistrySelected.departmentName != '';
    var isEmptyDepartment =
        hasDepartment && userDepartmentClassification == null;

    if (!registeredToChalleng ||
        userCompanyClassification == null ||
        userCyclistClassification == null ||
        isEmptyDepartment) {
      return const _EmptyChallenge();
    }

    return DefaultTabController(
      initialIndex: 0,
      length: hasDepartment ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 90.0,
          title: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Classifica',
                style: textTheme.headline5,
              ),
              DropdownButton<String>(
                items: listChallengeName.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: textTheme.caption,
                    ),
                  );
                }).toList(),
                value: challengeRegistrySelected?.challengeName,
                onChanged: (value) {
                  if (value != null) {
                    // viewModel.set
                  }
                },
              )
            ],
          ),
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            unselectedLabelStyle: textTheme.caption!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor: colorSchemeExtension.textSecondary,
            labelColor: colorSchemeExtension.textPrimary,
            labelStyle: textTheme.caption!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: <Widget>[
              Tab(
                text: 'Aziende'.toUpperCase(),
              ),
              if (hasDepartment)
                Tab(
                  text: 'Sedi / dip.'.toUpperCase(),
                ),
              Tab(
                text: 'Ciclisti'.toUpperCase(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            const ClassificationCompanyView(),
            if (hasDepartment) const DepartmentClassificationView(),
            const CyclistCompanyView(),
          ],
        ),
      ),
    );
  }
}

class _EmptyChallenge extends StatelessWidget {
  const _EmptyChallenge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              'Classifica',
              style: textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            height: (MediaQuery.of(context).size.height / 3) * 2,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.only(left: 23.0, right: 19.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Text(
                'La classifica è disponibile soltanto se partecipi a una challenge.',
                style: textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
