import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/admin/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/dashboard/widget/data_column_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    List<User> data = dashboardModel.uiState.listUser != null
        ? dashboardModel.uiState.listUser!.users
        : [];

    bool hasNextPage = dashboardModel.uiState.listUser != null
        ? dashboardModel.uiState.listUser!.pagination.hasNextPage
        : false;
    _tableDataSource = _TableDataSource(
      context: context,
      viewModel: dashboardModel,
      data: data,
      hasNextPage: hasNextPage,
      onTap: (user) async {
        // await dashboardModel.getUserInfo(user.uid);
        // await Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => AdminDetailsUser(
        //       user: user,
        //       userInfo: dashboardModel.uiState.userInfo,
        //       verifyUser: () {},
        //     ),
        //   ),
        // );
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
            onPressed: () {
              // _rowIndex.value = 0;
              // dashboardModel.getter();
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('Importa File CSV'),
            onPressed: () {
              // _rowIndex.value = 0;
              // dashboardModel.getter();
            },
            icon: const Icon(
              Icons.file_upload_outlined,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('Aggiorna'),
            onPressed: () {
              _rowIndex.value = 0;
              dashboardModel.getter();
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
                label: Text(''),
              ),
              DataColumn(
                label: DataColumnSearch(
                  title: 'EMAIL',
                  filter: dashboardModel.uiState.listUserEmailFilte ?? '',
                  onFilterChange: (value) {
                    if (value != null) {
                      _rowIndex.value = 0;
                      // dashboardModel.searchUserEmail(value);
                    } else {
                      _rowIndex.value = 0;
                      // dashboardModel.clearSearchUserEmail();
                    }
                  },
                ),
              ),
              const DataColumn(
                label: Text('UID'),
              ),
              const DataColumn(
                label: Text('NOME'),
              ),
              const DataColumn(
                label: Text('TIPO'),
              ),
              const DataColumn(
                label: Text(''),
              ),
            ],
            horizontalMargin: 50,
            checkboxHorizontalMargin: 10,
            showCheckboxColumn: false,
            showFirstLastButtons: false,
            rowsPerPage: dashboardModel.uiState.listUserPageSize,
            initialFirstRowIndex: _rowIndex.value,
            onPageChanged: (rowIndex) {
              _rowIndex.value = rowIndex;
              dashboardModel.nextPageListUser(rowIndex);
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
  late List<User> data;
  late Function(User) onTap;
  late bool hasNextPage;

  late int _selectedCount;
  late Color actionColor;

  _TableDataSource({
    required this.context,
    required this.viewModel,
    required this.data,
    required this.onTap,
    required this.hasNextPage,
  }) {
    _selectedCount = _getSelectedCounter(data);
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    actionColor = colorSchemeExtension.action;
  }

  int _getSelectedCounter(List<User> data) {
    return data.where((element) => element.selected).length;
  }

  selectAllItems(int page, bool selected) {
    var pageSize = viewModel.uiState.listUserPageSize;
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
  int get rowCount => hasNextPage ? data.length + 1 : data.length;

  @override
  int get selectedRowCount => _selectedCount;

  @override
  DataRow getRow(int index) {
    final user = data[index];
    return DataRow.byIndex(
      color: MaterialStateProperty.resolveWith(
        (Set states) {
          return null;
        },
      ),
      index: index,
      // selected: user.selected,
      onSelectChanged: (value) {
        onTap(user);
      },
      cells: [
        DataCell(
          Tooltip(
            message: user.verified ? 'VERIFICATO' : '',
            child: Badge(
              badgeColor: Colors.blueAccent,
              showBadge: user.verified,
              badgeContent: const Icon(
                Icons.star,
                color: Colors.white,
                size: 10.0,
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[400],
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? Icon(
                        Icons.person,
                        color: actionColor,
                      )
                    : Container(),
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'EMAIL',
            child: SelectableText(user.email),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'UID',
            child: SelectableText(user.uid),
          ),
        ),
        DataCell(
          Tooltip(
            message: 'NOME',
            child: SelectableText(user.displayName ?? 'N/A'),
          ),
        ),
        DataCell(
          Tooltip(
            message: user.admin ? 'ADMIN' : user.userType.name.toUpperCase(),
            child: _getUserTypeIcon(user.userType, user.admin),
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

  Widget _getUserTypeIcon(UserType userType, bool isAdmin) {
    const iconSize = 40.0;
    if (isAdmin) {
      return const Icon(
        Icons.admin_panel_settings_rounded,
        size: iconSize,
      );
    }

    switch (userType) {
      case UserType.other:
        return SvgPicture.asset(
          'assets/icons/profile.svg',
          height: iconSize,
          width: iconSize,
        );
      case UserType.mondora:
        return Image.asset(
          'assets/images/mondora_edition_logo.png',
          height: iconSize,
          width: iconSize,
        );
      case UserType.fiab:
        return Image.asset(
          'assets/images/fiab_edition_logo.png',
          height: iconSize,
          width: iconSize,
        );
    }
  }
}
