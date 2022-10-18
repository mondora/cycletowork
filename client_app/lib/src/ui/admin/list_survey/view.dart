import 'dart:math';

import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/admin/dashboard/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminListSurveyView extends StatefulWidget {
  const AdminListSurveyView({Key? key}) : super(key: key);

  @override
  State<AdminListSurveyView> createState() => _AdminListSurveyViewState();
}

class _AdminListSurveyViewState extends State<AdminListSurveyView>
    with RestorationMixin {
  final RestorableInt _rowIndex = RestorableInt(0);
  late _TableDataSource _tableDataSource;

  @override
  String? get restorationId => 'list_survey_table_etichetta';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_rowIndex, 'current_survey_row_index');
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
    List<Survey> data = dashboardModel.uiState.listSurvey;

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
            'Sondaggi',
            style: textTheme.headline6,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      restorationId: 'admin_list_survey',
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        title: Text(
          'Sondaggi',
          style: textTheme.headline6,
        ),
        actions: [
          TextButton.icon(
            label: const Text('Aggiungi'),
            onPressed: null,
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
              dashboardModel.getterListSurvey();
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
                label: Text('ID'),
              ),
              DataColumn(
                label: Text('NOME'),
              ),
              DataColumn(
                label: Text('È OBBLIGATORIO'),
              ),
              DataColumn(
                label: Text('N° DOMANDE'),
              ),
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
              dashboardModel.nextPageListSurvey(rowIndex);
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
  late List<Survey> data;
  late Function(Survey) onTap;

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

  int _getSelectedCounter(List<Survey> data) {
    return data.where((element) => element.selected).length;
  }

  selectAllItems(int page, bool selected) {
    var pageSize = viewModel.uiState.listCompanyPageSize;
    for (int index = page; index < min(page + pageSize, data.length); index++) {
      final user = data[index];
      user.selected = selected;
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
    final survey = data[index];
    return DataRow.byIndex(
      color: MaterialStateProperty.resolveWith(
        (Set states) {
          return null;
        },
      ),
      index: index,
      onSelectChanged: (value) {
        onTap(survey);
      },
      cells: [
        DataCell(
          Tooltip(
            message: 'ID',
            child: SelectableText(survey.id),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'NOME',
            child: SelectableText(survey.name),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'È OBBLIGATORIO',
            child: survey.required
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.lock_outline),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.lock_open_outlined),
                    ],
                  ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'N° DOMANDE',
            child: SelectableText(survey.listQuestion.length.toString()),
          ),
        ),
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
