//------------padding给子节点添加补白------------
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/user_dao.dart';
import 'package:flutter_app/common/model/user.dart';
import 'package:flutter_app/common/utils/common_utils.dart';

class PaddingTestRoute extends StatefulWidget {
  List<User> userList;
  PaddingTestRoute({this.userList});
  @override
  _PaddingTestState createState() {
    return new _PaddingTestState();
  }
}

class _PaddingTestState extends State<PaddingTestRoute> {

  @override
  Widget build(BuildContext context) {

    int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
    int _sortColumnIndex;
    bool _sortAscending = true;
    UserDataSource _userDataSource = UserDataSource();
    _userDataSource._users = widget.userList;


    void _sort<T>(Comparable<T> getField(User d), int columnIndex, bool ascending) {
      _userDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }

//    _userDataSource._users = ModalRoute.of(context).settings.arguments;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("padding_page"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(13.0),
          children: <Widget>[
            _userDataSource._users == null
            ?Center(child: CircularProgressIndicator())
            :PaginatedDataTable(
              actions: <Widget>[
                IconButton(icon: Icon(Icons.add), onPressed: null),
              ],
                header: const Text('Padding_Test'),
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (int value) { setState(() { _rowsPerPage = value; }); },
                sortColumnIndex: _sortColumnIndex,/*当前主排序的列的index*/
                sortAscending: _sortAscending,
                columns: <DataColumn>[
                  DataColumn(
                      label: const Text('姓名'),
                      onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.userName, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('年龄'),
                      tooltip: 'The total amount of food energy in the given serving size.',
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((User d) => d.age, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('爱好'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.hobby, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('电话'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.phone, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('住址'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.address, columnIndex, ascending)
                  ),
                ],
            )
          ],
        ),
      ),
    );
  }
}
//------------padding给子节点添加补白------------
class UserDataSource extends DataTableSource {
  /*数据源*/
  List<User> _users;

  int _selectedCount = 0;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _users.length;

  @override
  int get selectedRowCount => _selectedCount;

/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(User d),bool ascending){
    _users.sort((User a, User b) {
      if (!ascending) {
        final User c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    if (index >= _users.length)
      return null;
    final User user = _users[index];
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text('${user.userName}')),
          DataCell(Text('${user.age}')),
          DataCell(Text('${user.hobby}')),
          DataCell(Text('${user.phone}')),
          DataCell(Text('${user.address}')),
        ]);
  }
}
