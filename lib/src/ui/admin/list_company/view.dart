import 'dart:math';

import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/admin/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/admin/list_company/edit_company.dart';
import 'package:cycletowork/src/widget/data_column_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminListCompanyView extends StatefulWidget {
  const AdminListCompanyView({Key? key}) : super(key: key);

  @override
  State<AdminListCompanyView> createState() => _AdminListCompanyViewState();
}

class _AdminListCompanyViewState extends State<AdminListCompanyView>
    with RestorationMixin {
  final RestorableInt _rowIndex = RestorableInt(0);
  late _TableDataSource _tableDataSource;

  @override
  String? get restorationId => 'list_company_table_etichetta';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_rowIndex, 'current_company_row_index');
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
    List<Company> data = dashboardModel.uiState.listCompany;

    _tableDataSource = _TableDataSource(
      context: context,
      viewModel: dashboardModel,
      data: data,
      onTap: (company) async {
        var newCompany = await EditCompanyDialog(
          context: context,
          company: company,
        ).show();
        if (newCompany != null) {
          dashboardModel.updateCompany(newCompany);
        }
      },
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
            'Aziende',
            style: textTheme.headline6,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      restorationId: 'admin_list_company',
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        title: Text(
          'Aziende',
          style: textTheme.headline6,
        ),
        actions: [
          TextButton.icon(
            label: const Text('Aggiungi'),
            onPressed: () async {
              var newCompany = await EditCompanyDialog(context: context).show();
              if (newCompany != null) {
                _rowIndex.value = 0;
                dashboardModel.addCompany(newCompany);
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
              dashboardModel.getterListCompany();
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
            columns: [
              const DataColumn(
                label: Text('ID'),
              ),
              DataColumn(
                label: DataColumnSearch(
                  title: 'NOME',
                  filter: dashboardModel.uiState.listUserEmailFilte ?? '',
                  onFilterChange: (value) {
                    if (value != null) {
                      _rowIndex.value = 0;
                      dashboardModel.searchCompanyName(value);
                    } else {
                      _rowIndex.value = 0;
                      dashboardModel.clearSearchCompanyName();
                    }
                  },
                ),
              ),
              const DataColumn(
                label: Text('È VERIFICATA'),
              ),
              const DataColumn(
                label: Text('CATEGORIA'),
              ),
              const DataColumn(
                label: Text('N° DIPENDENTI'),
              ),
              const DataColumn(
                label: Text('CITTÀ'),
              ),
              const DataColumn(
                label: Text('HA DIPARTIMENTI'),
              ),
              const DataColumn(
                label: Text(''),
              ),
            ],
            horizontalMargin: 10,
            checkboxHorizontalMargin: 10,
            showCheckboxColumn: false,
            showFirstLastButtons: false,
            rowsPerPage: dashboardModel.uiState.listCompanyPageSize,
            initialFirstRowIndex: _rowIndex.value,
            onPageChanged: (rowIndex) {
              _rowIndex.value = rowIndex;
              dashboardModel.nextPageListCompany(rowIndex);
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
  late List<Company> data;
  late Function(Company) onTap;

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

  int _getSelectedCounter(List<Company> data) {
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
    final company = data[index];
    return DataRow.byIndex(
      color: MaterialStateProperty.resolveWith(
        (Set states) {
          return null;
        },
      ),
      index: index,
      // selected: user.selected,
      onSelectChanged: (value) {
        onTap(company);
      },
      cells: [
        DataCell(
          Tooltip(
            message: 'ID',
            child: SelectableText(company.id),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'NOME',
            child: SelectableText(company.name),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'VERIFICARE',
            child: Switch(
              value: company.isVerified,
              onChanged: !company.isVerified
                  ? (value) async {
                      bool? isConfirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('CANCELLARE'),
                          content: Text(
                              'SEI SICURO DI VERIFICARE LA AZIENDA "${company.name}"?'),
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
                        viewModel.verifyCompany(company);
                      }
                    }
                  : null,
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'CATEGORIA',
            child: SelectableText(company.category),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'N° DIPENDENTI',
            child: SelectableText(company.employeesNumber.toString()),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'CITTÀ',
            child: SelectableText(company.city),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'HA DIPARTIMENTI',
            child: company.hasMoreDepartment == true
                ? Row(
                    children: const [
                      Text('SI'),
                      SizedBox(width: 10),
                      Icon(Icons.apartment),
                    ],
                  )
                : Row(
                    children: const [
                      Text('NO'),
                      SizedBox(width: 10),
                      Icon(Icons.domain_disabled),
                    ],
                  ),
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
