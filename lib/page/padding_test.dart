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

    TextEditingController _userNameController = new TextEditingController();
    TextEditingController _ageController = new TextEditingController();
    TextEditingController _hobbyController = new TextEditingController();
    TextEditingController _phoneController = new TextEditingController();
    TextEditingController _addressController = new TextEditingController();
    GlobalKey _formKey= new GlobalKey<FormState>();

    _addUserDialog() {
      return SimpleDialog(
        title: Text('新增用户'),
        titlePadding: EdgeInsets.only(left: 100,top: 10),
        children: <Widget>[
          Form(
            key: _formKey, //设置globalKey，用于后面获取FormState
            autovalidate: true, //开启自动校验
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    autofocus: false,
                    controller: _userNameController,
                    decoration: InputDecoration(
                        labelText: "姓名",
                        hintText: "用户姓名或昵称",
                    ),
                    // 校验用户名
                    validator: (v) {
                      return v
                          .trim()
                          .length > 0 ? null : "用户名不能为空";
                    }

                ),
                TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                        labelText: "年龄",
                        hintText: "请正确输入年龄",
                    ),
                    //校验年龄
                    validator: (v) {
                      RegExp exp = RegExp(
                          r'^(?:[1-9][0-9]?|1[01][0-9]|120)$');
                      bool matched = exp.hasMatch(v);
                      return matched ? null : "错误的年龄";
                    }
                ),
                TextFormField(
                    controller: _hobbyController,
                    decoration: InputDecoration(
                        labelText: "爱好",
                        hintText: "喜欢或擅长的事情",
                    ),
                ),
                TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        labelText: "电话",
                        hintText: "请输入正确的移动号码",
                    ),
                    //校验密码
                    validator: (v) {
                      RegExp exp = RegExp(
                          r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                      bool matched = exp.hasMatch(v);
                      return matched ? null : "不是正确的电话号码";
                    }
                ),
                TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        labelText: "住址",
                        hintText: "请输入正确的住址",
                    ),
                ),
                Row(
                  children: <Widget>[
                    new FlatButton(
                      child: new Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("确定"),
                      onPressed: () {
                        if((_formKey.currentState as FormState).validate()){
                          //验证通过提交数据
                          UserDao userDao = new UserDao();
                          User user = new User(
                              null,
                              _userNameController.text,
                              int.parse(_ageController.text),
                              _hobbyController.text,
                              _phoneController.text,
                              _addressController.text
                          );
                          userDao.addUser(CommonUtils.Connection, user).then((v){
                            if(v > 0){
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
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
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: true,//点击dialog外部是否可以销毁
                        builder: (BuildContext context) {
                          return _addUserDialog();
                        },
                      ).then((val) {
                        print(val);
                      });
                    },
                ),
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
                    onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.hobby, columnIndex, ascending)
                ),
                DataColumn(
                    label: const Text('电话'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.phone, columnIndex, ascending)
                ),
                DataColumn(
                    label: const Text('住址'),
                    onSort: (int columnIndex, bool ascending) => _sort<String>((User d) => d.address, columnIndex, ascending)
                ),
                DataColumn(
                    label: const Text('操作'),
                ),
              ],
            source: _userDataSource,

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
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new RaisedButton(
                  child: new Text("修改"),
                  onPressed: () {
                    TeamPage;
                  },
                ),
                new RaisedButton(
                  child: new Text("删除"),
                  onPressed: () {
                    return TeamPage;
                  },
                ),
              ],
            )
          ),
    ]);
  }
}

showMyMaterialDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text("title"),
          content: new Text("内容内容内容内容内容内容内容内容内容内容内容"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("确认"),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("取消"),
            ),
          ],
        );
      });
}


class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('确定退出程序吗?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('暂不'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('title'),
        ),
        body: Center(
          child: Text('exit'),
        ),
      ),
    );
  }
}