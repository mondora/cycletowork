import 'dart:math';

import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/admin/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/admin/list_challenge/edit_challenge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminListChallengeView extends StatefulWidget {
  const AdminListChallengeView({Key? key}) : super(key: key);

  @override
  State<AdminListChallengeView> createState() => _AdminListChallengeViewState();
}

class _AdminListChallengeViewState extends State<AdminListChallengeView>
    with RestorationMixin {
  final RestorableInt _rowIndex = RestorableInt(0);
  late _TableDataSource _tableDataSource;

  @override
  String? get restorationId => 'list_challenge_table_etichetta';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_rowIndex, 'current_challenge_row_index');
  }

  @override
  void dispose() {
    _tableDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardModel = Provider.of<ViewModel>(context);
    var textTheme = Theme.of(context).textTheme;
    List<Challenge> data = dashboardModel.uiState.listChallenge;

    _tableDataSource = _TableDataSource(
      context: context,
      viewModel: dashboardModel,
      data: data,
      onTap: (company) async {},
    );

    if (dashboardModel.uiState.loading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          title: Text(
            'Challenge',
            style: textTheme.headline6,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      restorationId: 'admin_list_challenge',
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        title: Text(
          'Challenge',
          style: textTheme.headline6,
        ),
        actions: [
          TextButton.icon(
            label: const Text('Aggiungi'),
            onPressed: () async {
              var newChallenge =
                  await EditChallengeDialog(context: context).show();
              if (newChallenge != null) {
                _rowIndex.value = 0;
                dashboardModel.addChallenge(newChallenge);
              }
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('Aggiorna'),
            onPressed: () {
              _rowIndex.value = 0;
              dashboardModel.getterListChallenge();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: PaginatedDataTable(
            source: _tableDataSource,
            header: const Text('Tabella'),
            columns: const [
              DataColumn(
                label: Text('NOME'),
              ),
              DataColumn(
                label: Text('INZIA'),
              ),
              DataColumn(
                label: Text('FINE'),
              ),
              DataColumn(
                label: Text('È PUBLICATO'),
              ),
              DataColumn(
                label: Text('EDIZIONE FIAB'),
              ),
              DataColumn(
                label: Text('È OBBL. SONDAGGIO'),
              ),
              DataColumn(
                label: Text('È OBBL. Selezione Azienda'),
              ),
              DataColumn(
                label: Text('È OBBL. NOME E COGNOME'),
              ),
              DataColumn(
                label: Text('È OBBL. EMAIL AZIENDALE'),
              ),
              DataColumn(
                label: Text('È OBBL. VERIFICA EMAIL AZIENDALE'),
              ),
              DataColumn(
                label: Text('È OBBL. INDIRIZZO AZIENDALE'),
              ),
              DataColumn(
                label: Text('N° DOMANDE'),
              ),
              // DataColumn(
              //   label: Text('È PUBLICATO'),
              // ),
              DataColumn(
                label: Text(''),
              ),
            ],
            horizontalMargin: 50,
            checkboxHorizontalMargin: 10,
            showCheckboxColumn: false,
            showFirstLastButtons: false,
            rowsPerPage: dashboardModel.uiState.listCompanyPageSize,
            initialFirstRowIndex: _rowIndex.value,
            onPageChanged: (rowIndex) {
              _rowIndex.value = rowIndex;
              dashboardModel.nextPageListChallenge(rowIndex);
            },
            onSelectAll: (value) {},
          ),
        ),
      ),
    );
  }
}

class _TableDataSource extends DataTableSource {
  late BuildContext context;
  late ViewModel viewModel;
  late List<Challenge> data;
  late Function(Challenge) onTap;

  late int _selectedCount;
  late Color actionColor;

  _TableDataSource({
    required this.context,
    required this.viewModel,
    required this.data,
    required this.onTap,
  }) {
    _selectedCount = _getSelectedCounter(data);
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    actionColor = colorSchemeExtension.action;
  }

  int _getSelectedCounter(List<Challenge> data) {
    return data.where((element) => element.selected).length;
  }

  selectAllItems(int page, bool selected) {
    var pageSize = viewModel.uiState.listCompanyPageSize;
    for (int index = page; index < min(page + pageSize, data.length); index++) {
      final challenge = data[index];
      challenge.selected = selected;
    }
    _selectedCount = _getSelectedCounter(data);
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => _selectedCount;

  @override
  DataRow getRow(int index) {
    final Locale appLocale = Localizations.localeOf(context);
    final formatterDate = DateFormat(
      'dd MMMM yyyy, HH:mm',
      appLocale.languageCode,
    );
    final challenge = data[index];
    final startDate = DateTime.fromMillisecondsSinceEpoch(
      challenge.startTime,
    );
    final stopDate = DateTime.fromMillisecondsSinceEpoch(
      challenge.stopTime,
    );
    return DataRow.byIndex(
      color: MaterialStateProperty.resolveWith(
        (Set states) {
          return null;
        },
      ),
      index: index,
      onSelectChanged: (value) {
        onTap(challenge);
      },
      cells: [
        DataCell(
          Tooltip(
            message: 'NOME',
            child: SelectableText(challenge.name),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'INZIA',
            child: SelectableText(
              formatterDate.format(startDate),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'FINE',
            child: SelectableText(
              formatterDate.format(stopDate),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'PUBLICARE',
            child: Switch(
              value: challenge.published,
              onChanged: !challenge.published
                  ? (value) async {
                      bool? isConfirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('CANCELLARE'),
                          content: Text(
                              'SEI SICURO DI PUBLICARE "${challenge.name}"?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('ANNULA'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('CONFERMA'),
                            ),
                          ],
                        ),
                      );
                      if (isConfirmed == true) {
                        viewModel.publishChallenge(challenge);
                      }
                    }
                  : null,
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'EDIZIONE FIAB',
            child: challenge.fiabEdition
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBL. SONDAGGIO',
            child: challenge.requiredSurvey
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBL. Selezione Azienda',
            child: challenge.requiredCompany
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBL. NOME E COGNOME',
            child: challenge.requiredNameLastName
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBL. EMAIL AZIENDALE',
            child: challenge.requiredBusinessEmail
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBL. VERIFICA EMAIL AZIENDALE',
            child: challenge.requiredBusinessEmailVerification
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBL. INDIRIZZO AZIENDALE',
            child: challenge.requiredWorkAddress
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.unpublished_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'N° DOMANDE',
            // child: SelectableText(challenge.listQuestion.length.toString()),
            child: SelectableText("N/A"),
          ),
        ),
        // DataCell(
        //   Tooltip(
        //     message: 'È PUBLICATO',
        //     child: challenge.published
        //         ? Row(
        //             children: const [
        //               Text('SI'),
        //               SizedBox(width: 10),
        //               Icon(Icons.public_outlined),
        //             ],
        //           )
        //         : Row(
        //             children: const [
        //               Text('NO'),
        //               SizedBox(width: 10),
        //               Icon(Icons.public_off_outlined),
        //             ],
        //           ),
        //   ),
        // ),
        // DataCell(
        //   Tooltip(
        //     message: 'PUBLICARE',
        //     child: IconButton(
        //       onPressed: !challenge.published
        //           ? () async {
        //               bool? isConfirmed = await showDialog<bool>(
        //                 context: context,
        //                 builder: (BuildContext context) => AlertDialog(
        //                   title: const Text('CANCELLARE'),
        //                   content: Text(
        //                       'SEI SICURO DI PUBLICARE "${challenge.name}"?'),
        //                   actions: <Widget>[
        //                     TextButton(
        //                       onPressed: () => Navigator.pop(context, false),
        //                       child: const Text('ANNULA'),
        //                     ),
        //                     TextButton(
        //                       onPressed: () => Navigator.pop(context, true),
        //                       child: const Text('CONFERMA'),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //               if (isConfirmed == true) {
        //                 viewModel.publishChallenge(challenge);
        //               }
        //             }
        //           : null,
        //       icon: Icon(Icons.),
        //     ),
        //   ),
        // ),
        const DataCell(
          Tooltip(
            message: 'DETTAGLI',
            child: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }
}
