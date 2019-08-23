//------------padding给子节点添加补白------------
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/user_dao.dart';
import 'package:flutter_app/common/model/user.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:dio/dio.dart';

class PaddingTestRoute extends StatefulWidget {
  List<User> userList;
  PaddingTestRoute({this.userList});
  @override
  _PaddingTestState createState() {
    return new _PaddingTestState();
  }
}

class _PaddingTestState extends State<PaddingTestRoute> {
  List<User> _users = new List();

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _hobbyController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  Future<Null> _refreshUser() async {
    UserDao userDao = UserDao();
    userDao.getAllUser(CommonUtils.Connection, 0, 0).then((users) {
      setState(() {
        _users.removeRange(0, _users.length);
        _users.addAll(users);
      });
    });
  }

  Dio dio = new Dio();
  Future<Response> getLocationWeather() async {
    var response = await dio.get("http://v.juhe.cn/weather/index?format=2&cityname=%e4%b9%90%e5%b1%b1&key=74561ef2bc60f44a2fc406ec2100927e");
    if(null != response && response.statusCode == 200){
      return response;
    }else{
      null;
    }
  }

  var initUser;

  @override
  void initState() {
    super.initState();

    getLocationWeather().then((result){
        if(null != result){
          debugPrint(result.toString());
        }else{
          print("---------------------请求失败-----------------------");
        }
    });

    if (CommonUtils.IsOpenDB) {
      UserDao userDao = new UserDao();
      userDao.getAllUser(CommonUtils.Connection, 0, 0).then((result) {
        initUser = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    _users = widget.userList; //第二种路由传值
    _users = initUser;//均可使用的传值
//    _users = ModalRoute.of(context).settings.arguments; 第一只种路由传值

    _addUserDialog() {
      _userNameController.clear();
      _ageController.clear();
      _hobbyController.clear();
      _phoneController.clear();
      _addressController.clear();
      return SimpleDialog(
        title: Text('新增用户'),
        titlePadding: EdgeInsets.only(left: 100, top: 10),
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
                      return v.trim().length > 0 ? null : "用户名不能为空";
                    }),
                TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: "年龄",
                      hintText: "请正确输入年龄",
                    ),
                    //校验年龄
                    validator: (v) {
                      RegExp exp = RegExp(r'^(?:[1-9][0-9]?|1[01][0-9]|120)$');
                      bool matched = exp.hasMatch(v);
                      return matched ? null : "错误的年龄";
                    }),
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
                    }),
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
                        if ((_formKey.currentState as FormState).validate()) {
                          //验证通过提交数据
                          UserDao userDao = new UserDao();
                          User user = User(
                            userName: _userNameController.text,
                            age: int.parse(_ageController.text),
                            hobby: _hobbyController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                          );
                          userDao
                              .addUser(CommonUtils.Connection, user)
                              .then((v) {
                            if (v > 0) {
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

    _updateUserDialog(User user) {
      _userNameController.text = user.userName;
      _ageController.text = user.age.toString();
      _hobbyController.text = user.hobby;
      _phoneController.text = user.phone;
      _addressController.text = user.address;
      return SimpleDialog(
        title: Text('修改用户'),
        titlePadding: EdgeInsets.only(left: 100, top: 10),
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
                      return v.trim().length > 0 ? null : "用户名不能为空";
                    }),
                TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: "年龄",
                      hintText: "请正确输入年龄",
                    ),
                    //校验年龄
                    validator: (v) {
                      RegExp exp = RegExp(r'^(?:[1-9][0-9]?|1[01][0-9]|120)$');
                      bool matched = exp.hasMatch(v);
                      return matched ? null : "错误的年龄";
                    }),
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
                    }),
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
                        if ((_formKey.currentState as FormState).validate()) {
                          //验证通过提交数据
                          UserDao userDao = new UserDao();
                          User newUser = User(
                            id: user.id,
                            userName: _userNameController.text,
                            age: int.parse(_ageController.text),
                            hobby: _hobbyController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                          );
                          userDao
                              .updateUser(CommonUtils.Connection, newUser)
                              .then((v) {
                            if (null != v) {
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

    _deleteUserDialog(User user) {
      return AlertDialog(
        title: Text('确定删除当前用户?'),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              UserDao userDao = UserDao();
              userDao.deleteUser(CommonUtils.Connection, user).then((n) {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      );
    }


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("padding_page"),
        ),
        body: Container(
            //集合了下拉手势、加载指示器和刷新操作一体
            child: RefreshIndicator(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _users == null
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new CupertinoButton(
                              child: new Text("新增"),
                              padding: EdgeInsets.only(left: 10),
                              onPressed: () {
                                showDialog<Null>(
                                  context: context,
                                  barrierDismissible: true, //点击dialog外部是否可以销毁
                                  builder: (BuildContext context) {
                                    return _addUserDialog();
                                  },
                                ).then((v) {
                                  _refreshUser();
                                });
                              },
                            ),
                          ],
                        ),
                        DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: const Text('姓名'),
                              ),
                              DataColumn(
                                label: const Text('年龄'),
                                tooltip:
                                    'The total amount of food energy in the given serving size.',
                                numeric: true,
                              ),
                              DataColumn(
                                label: const Text('爱好'),
                              ),
                              DataColumn(
                                label: const Text('电话'),
                                numeric: true,
                              ),
                              DataColumn(
                                label: const Text('住址'),
                              ),
                              DataColumn(
                                label: const Text('操作'),
                              ),
                            ],
                            rows: _users.map((user) {
                              return DataRow(cells: [
                                DataCell(Text(user.userName)),
                                DataCell(Text(user.age.toString())),
                                DataCell(Text(user.hobby)),
                                DataCell(Text(user.phone)),
                                DataCell(Text(user.address)),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new RaisedButton(
                                      child: new Text("修改"),
                                      onPressed: () {
                                        showDialog<Null>(
                                          context: context,
                                          barrierDismissible:
                                              true, //点击dialog外部是否可以销毁
                                          builder: (BuildContext context) {
                                            //此处可传入ID，然后在update方法处进行查询显示。
                                            return _updateUserDialog(user);
                                          },
                                        ).then((v) {
                                          _refreshUser();
                                        });
                                      },
                                    ),
                                    new RaisedButton(
                                      child: new Text("删除"),
                                      onPressed: () {
                                        showDialog<Null>(
                                          context: context,
                                          barrierDismissible:
                                              true, //点击dialog外部是否可以销毁
                                          builder: (BuildContext context) {
                                            return _deleteUserDialog(user);
                                          },
                                        ).then((v) {
                                          _refreshUser();
                                        });
                                      },
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList())
                      ],
                    ),
                ],
              ),
          onRefresh: _refreshUser,
        )),
      ),
    );
  }
}
