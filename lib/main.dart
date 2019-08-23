import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/page/lifecycle_test.dart';
import 'package:flutter_app/page/padding_test.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/src/widgets/basic.dart' as Basic;
import 'common/dao/user_dao.dart';
import 'common/utils/common_utils.dart';

void main() async {
  // void main() => runApp(new MyApp());

  var settings = new ConnectionSettings(
    host: CommonUtils.HOST,
    port: CommonUtils.PORT,
    user: CommonUtils.USER,
    password: CommonUtils.PASSWORD,
    db: CommonUtils.DB,
  );
  print("opening mysql");
  CommonUtils.Connection = await MySqlConnection.connect(settings);
  if (null != CommonUtils.Connection) {
    CommonUtils.IsOpenDB = true;
    print("opened mysql");
  }
  return runApp(new MyApp());
}

//---------------HelloWorld App------------------
class HelloWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Container(
          child: new Text('Hello World'),
        ),
      ),
    );
  }
}
//---------------第一个HelloWorld App------------------

//---------------引入外部包生成随机驼峰式单词------------------
class OneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new Text(wordPair.asPascalCase),
        ),
      ),
    );
  }
}
//---------------引入外部包生成随机驼峰式单词------------------

//---------------添加有状态的部件------------------
class TwoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new RandomWordsTwo(),
        ),
      ),
    );
  }
}

class RandomWordsTwo extends StatefulWidget {
  @override
  createState() => new RandomWordsTwoState();
}

class RandomWordsTwoState extends State<RandomWordsTwo> {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new Text(wordPair.asPascalCase);
  }
}
//---------------添加有状态的部件------------------

//---------------创建一个无限滚动ListView------------------
class ThreeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWordsThree(),
    );
  }
}

class RandomWordsThree extends StatefulWidget {
  @override
  createState() => new RandomWordsThreeState();
}

class RandomWordsThreeState extends State<RandomWordsThree> {
  final _suggestions = <WordPair>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议列表中的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
//---------------创建一个无限滚动ListView------------------

//---------------添加互动------------------
class FourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWordsFour(),
    );
  }
}

class RandomWordsFour extends StatefulWidget {
  @override
  createState() => new RandomWordsFourState();
}

class RandomWordsFourState extends State<RandomWordsFour> {
  final _suggestions = <WordPair>[];

  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
//---------------添加互动------------------

//---------------导航到新页面------------------
class FiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWordsFive(),
    );
  }
}

class RandomWordsFive extends StatefulWidget {
  @override
  createState() => new RandomWordsFiveState();
}

class RandomWordsFiveState extends State<RandomWordsFive> {
  final _suggestions = <WordPair>[];

  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
//---------------导航到新页面------------------

//---------------容器类widget------------------

//------------Scaffold、TabBar、底部导航
class ScaffoldBoxTestRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldBoxTestRoute>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["新闻", "历史", "图片"];

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ModalRoute.of(context).settings.arguments),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      drawer: new MyDrawer(),
      body: TabBarView(
          controller: _tabController,
          children: tabs.map((e) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                e,
                textScaleFactor: 5,
              ),
            );
          }).toList()),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Basic.Row(
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {},),
            SizedBox(), //中间位置空出
            IconButton(icon: Icon(Icons.business), onPressed: () {},),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAdd() {}
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Basic.Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image.asset(
                        "imgs/avatar.png",
                        width: 60.0,
                      ),
                    ),
                  ),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
//------------Scaffold、TabBar、底部导航

//---------------Container万能容器---------------
class ContainerBoxTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          //child: new Text('Hello World'),
          child: new Text(wordPair.asPascalCase),
        ),
      ),
    );
  }
}
//---------------Container万能容器---------------

//-----------DecoratedBox绘制类容器-------------
class DecoratedBoxTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args),
      ),
      body: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange[700]]), //背景渐变
              borderRadius: BorderRadius.circular(3.0), //3像素圆角
              boxShadow: [
                //阴影
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0)
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 18.0),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
//-----------DecoratedBox绘制类容器-------------

//-----------ConstrainedBoX限制子类widget大小------------------
class ConstrainedBoXTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args),
        actions: <Widget>[
          //SizedBox
          UnconstrainedBox(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.white70),
              ),
            ),
          )
        ],
      ),
      body: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 60.0, minHeight: 100.0), //父
          child: UnconstrainedBox(
            //“去除”父级限制
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 90.0, minHeight: 20.0), //子
              child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.deepOrange)),
            ),
          )),
    );
  }
}
//-----------ConstrainedBoX限制子类widget大小------------------

//---------------容器类widget------------------

//----------------布局类widget------------------

//---------------层叠布局---------------
class StackLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 8.0, // 主轴(水平)方向间距
            runSpacing: 8.0, // 纵轴（垂直）方向间距
            alignment: WrapAlignment.center, //沿主轴方向居中
            children: <Widget>[
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('A')),
                label: new Text('Hamilton'),
              ),
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('M')),
                label: new Text('Lafayette'),
              ),
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('H')),
                label: new Text('Mulligan'),
              ),
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('J')),
                label: new Text('Laurens'),
              ),
            ],
          ),
          Flow(
            delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
            children: <Widget>[
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.red,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.green,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.blue,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.yellow,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.brown,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.purple,
              ),
            ],
          ),
          //层叠布局未生效
          /*Stack(
            alignment:Alignment.center ,
            fit: StackFit.expand, //未定位widget占满Stack整个空间
            children: <Widget>[
              Positioned(
                left: 18.0,
                child: Text("I am Jack"),
              ),
              Container(child: Text("Hello world",style: TextStyle(color: Colors.white)),
                color: Colors.red,
              ),
              Positioned(
                top: 18.0,
                child: Text("Your friend"),
              )
            ],
          ),*/
        ],
      ),
    );
  }
}
//---------------层叠布局---------------

//---------------流式布局---------------
class WrapLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 8.0, // 主轴(水平)方向间距
            runSpacing: 8.0, // 纵轴（垂直）方向间距
            alignment: WrapAlignment.center, //沿主轴方向居中
            children: <Widget>[
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('A')),
                label: new Text('Hamilton'),
              ),
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('M')),
                label: new Text('Lafayette'),
              ),
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('H')),
                label: new Text('Mulligan'),
              ),
              new Chip(
                avatar: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Text('J')),
                label: new Text('Laurens'),
              ),
            ],
          ),
          Flow(
            delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
            children: <Widget>[
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.red,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.green,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.blue,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.yellow,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.brown,
              ),
              new Container(
                width: 80.0,
                height: 80.0,
                color: Colors.purple,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;
  TestFlowDelegate({this.margin});
  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
//---------------流式布局---------------

//----------------弹性布局---------------
class FlexLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Flex的两个子widget按1：2来占据水平空间
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 30.0,
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 30.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: 100.0,
            //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30.0,
                    color: Colors.red,
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30.0,
                    color: Colors.green,
                    child: Basic.Row(
                      children: <Widget>[
                        Text("ddd" * 5, style: TextStyle(fontSize: 10.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: <Widget>[
            new Chip(
              label:new Text("Hamilton"),
              avatar: new CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
            ),
          ],
        ),*/
      ],
    );
  }
}
//----------------弹性布局---------------

//--------------线性布局------------------
class RowAndColumnTest extends StatefulWidget {
  @override
  _RowAndColumnTestState createState() => new _RowAndColumnTestState();
}

class _RowAndColumnTestState extends State<RowAndColumnTest> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        child: Form(
          key: _formKey, //设置globalKey，用于后面获取FormState
          autovalidate: true, //开启自动校验
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: InputDecoration(
                      labelText: "用户名",
                      hintText: "用户名或邮箱",
                      icon: Icon(Icons.person)),
                  // 校验用户名
                  validator: (v) {
                    return v.trim().length > 0 ? null : "用户名不能为空";
                  }),
              TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                      labelText: "密码",
                      hintText: "您的登录密码",
                      icon: Icon(Icons.lock)),
                  obscureText: true,
                  //校验密码
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密码不能少于6位";
                  }),
              // 登录按钮
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Basic.Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("登录"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          //在这里不能通过此方式获取FormState，context不对
                          //print(Form.of(context));

                          // 通过_formKey.currentState 获取FormState后，
                          // 调用validate()方法校验用户名密码是否合法，校验
                          // 通过后再提交数据。
                          if ((_formKey.currentState as FormState).validate()) {
                            //验证通过提交数据
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Basic.Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("aaaaaaaa"),
                  Text("bbbbbbbb"),
                ],
              ),
              Basic.Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("cccccccc"),
                  Text("dddddddd"),
                ],
              ),
              Basic.Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Text("eeeeeeee"),
                  Text("ffffffff"),
                ],
              ),
              Basic.Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  Text(
                    "gggggggggg",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Text("hhhhhhhhh"),
                ],
              ),
              Container(
                color: Colors.greenAccent,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("aaaaaa"),
                              Text("bbbbbbb"),
                              Text("bbbbbbb"),
                              Text("bbbbbbb"),
                            ],
                          ),
                        )),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//--------------线性布局------------------

//----------------布局类widget------------------

//----------------基础类widget------------------

//----------------输入框验证---------------
class FormTestRoute extends StatefulWidget {
  @override
  _FormTestRouteState createState() => new _FormTestRouteState();
}

class _FormTestRouteState extends State<FormTestRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        child: Form(
          key: _formKey, //设置globalKey，用于后面获取FormState
          autovalidate: true, //开启自动校验
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: InputDecoration(
                      labelText: "用户名",
                      hintText: "用户名或邮箱",
                      icon: Icon(Icons.person)),
                  // 校验用户名
                  validator: (v) {
                    return v.trim().length > 0 ? null : "用户名不能为空";
                  }),
              TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                      labelText: "密码",
                      hintText: "您的登录密码",
                      icon: Icon(Icons.lock)),
                  obscureText: true,
                  //校验密码
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密码不能少于6位";
                  }),
              // 登录按钮
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Basic.Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("登录"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          //在这里不能通过此方式获取FormState，context不对
                          //print(Form.of(context));

                          // 通过_formKey.currentState 获取FormState后，
                          // 调用validate()方法校验用户名密码是否合法，校验
                          // 通过后再提交数据。
                          if ((_formKey.currentState as FormState).validate()) {
                            //验证通过提交数据
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//----------------输入框验证---------------

//--------------输入框测试----------------
class FocusTestRoute extends StatefulWidget {
  @override
  _FocusTestRouteState createState() => new _FocusTestRouteState();
}

class _FocusTestRouteState extends State<FocusTestRoute> {
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusScopeNode focusScopeNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            focusNode: focusNode1, //关联focusNode1
            decoration: InputDecoration(labelText: "input1"),
          ),
          TextField(
            focusNode: focusNode2, //关联focusNode2
            decoration: InputDecoration(labelText: "input2"),
          ),
          Builder(
            builder: (ctx) {
              return Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("移动焦点"),
                    onPressed: () {
                      //将焦点从第一个TextField移到第二个TextField
                      // 这是一种写法 FocusScope.of(context).requestFocus(focusNode2);
                      // 这是第二种写法
                      if (null == focusScopeNode) {
                        focusScopeNode = FocusScope.of(context);
                      }
                      focusScopeNode.requestFocus(focusNode2);
                    },
                  ),
                  RaisedButton(
                    child: Text("隐藏键盘"),
                    onPressed: () {
                      // 当所有编辑框都失去焦点时键盘就会收起
                      focusNode1.unfocus();
                      focusNode2.unfocus();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
//--------------输入框测试----------------

//-----------CupertiNo组件库--------------
class CupertinoTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Daysi's Cupertino"),
        ),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
                color: CupertinoColors.activeGreen,
                child: Text('Benjamin'),
                onPressed: () {}),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "用户名或邮箱",
                  prefixIcon: Icon(Icons.person)),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "您的登录密码",
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
          ],
        )));
  }
}
//-----------CupertiNo组件库--------------

//----------------基础类widget------------------

//---------------混合管理------------------
class TapboxC extends StatefulWidget {
  final bool active;
  final ValueChanged<bool> onChanged;

  TapboxC({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  @override
  _TapboxCState createState() => new _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: new Container(
        child: new Center(
          child: new Text(
            widget.active ? 'Twisted' : 'No Twisted',
            style: new TextStyle(fontSize: 32, color: Colors.black87),
          ),
        ),
        width: 160,
        height: 160,
        decoration: new BoxDecoration(
          color: widget.active ? Colors.lightGreen : Colors.tealAccent,
          border:
              _highlight ? new Border.all(color: Colors.teal, width: 10) : null,
        ),
      ),
    );
  }
}

class ParentWidgetC extends StatefulWidget {
  @override
  _ParentWidgetCState createState() => new _ParentWidgetCState();
}

class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new TapboxC(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}
//---------------混合管理------------------

//-------父widget管理子widget的state-------
class TapboxB extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;

  TapboxB({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  void _handleTap() {
    onChanged(!active);
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _handleTap,
      child: new Container(
        child: new Center(
          child: new Text(
            active ? 'Twisted' : 'No Twisted',
            style: new TextStyle(fontSize: 32.0, color: Colors.greenAccent),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: new BoxDecoration(
          color: active ? Colors.lightBlue : Colors.lightGreen,
        ),
      ),
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => new _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new TapboxC(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}
//-------父widget管理子widget的state-------

//-------widget管理自身状态----------
class TapboxA extends StatefulWidget {
  TapboxA({Key key}) : super(key: key);

  @override
  _TapboxAState createState() => new _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _handleTap,
      child: new Container(
        child: new Center(
          child: new Text(_active ? 'Active' : 'Inactive',
              style: new TextStyle(fontSize: 12.0, color: Colors.amber)),
        ),
        width: 200.0,
        height: 200.0,
        decoration: new BoxDecoration(
          color: _active ? Colors.lightGreen[200] : Colors.grey[300],
        ),
      ),
    );
  }
}
//-------widget管理自身状态----------

//-------------state生命周期---------------
class CounterWidget extends StatefulWidget {
  final int initValue;

  const CounterWidget({
    Key key,
    this.initValue = 0,
  });

  @override
  _CounterWidgetState createState() => new _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter;
  void initState() {
    super.initState();
    _counter = widget.initValue;
    print("Twisted initState");
  }

  @override
  Widget build(BuildContext context) {
    print("Twisted build");
//    return Scaffold(
//      body: Center(
//        child: FlatButton(
//            onPressed:()=>setState(()=>++_counter),
//            child: Text('$_counter')),
//      ),
//    );
    return Text("Twisted XXXX");
  }

  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactive");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}

//-------------state生命周期---------------
class EchoHome extends StatelessWidget {
  Widget build(BuildContext context) {
    return Echo(
      text: "Twisted Fate",
      backgroundColor: Colors.purple,
    );
  }
}

class Echo extends StatelessWidget {
  const Echo({
    Key key,
    @required this.text,
    this.backgroundColor,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

class AppHome extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Material(
      child: new Center(
        child: new FlatButton(
            onPressed: () {
//              debugDumpApp();//状态或事件转储
//              debugDumpRenderTree();//转储渲染树
//              debugDumpLayerTree();//调试合成
//              debugDumpSemanticsTree();//语义树
            },
            child: new Text('Dump App')),
      ),
    );
  }
}

class RandomWordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: new Text(wordPair.toString()),
    );
  }
}

class TestAsset extends StatelessWidget {
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('graphics/background.png'),
        ),
      ),
    );
  }
}

class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args),
      ),
      body: Center(
        child: Text('this is Twisted丶Fate route'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      routes: {
        "padding_page": (context) => PaddingTestRoute(),
        "ConstrainedBox": (context) => ConstrainedBoXTestRoute(),
        "DecoratedBox": (context) => DecoratedBoxTestRoute(),
        "ContainerBox": (context) => ContainerBoxTestRoute(),
        "ScaffoldBox": (context) => ScaffoldBoxTestRoute(),
        "Lifecycle": (context) => LifecyclePage(),
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      print('Twisted:' + _counter.toString());
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var conn = CommonUtils.Connection;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CupertinoButton(
              child: Text(
                "PaddingBox",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.yellow,
              onPressed: () {
//                Navigator.of(context).pushNamed("padding_page",arguments: result);
                if (CommonUtils.IsOpenDB) {
                  UserDao userDao = new UserDao();
                  userDao.getAllUser(conn, 0, 0).then((result) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaddingTestRoute(userList: result)));
                  });
                }
              },
            ),
            CupertinoButton(
              child: Text(
                "ConstrainedBox",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context).pushNamed("ConstrainedBox",
                    arguments: "ConstrainedBox_page");
              },
            ),
            CupertinoButton(
              child: Text(
                "DecoratedBox",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed("DecoratedBox", arguments: "DecoratedBox_page");
              },
            ),
            CupertinoButton(
              child: Text(
                "ContainerBox",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed("ContainerBox", arguments: "ContainerBox_page");
              },
            ),
            CupertinoButton(
              child: Text(
                "ScaffoldBox",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed("ScaffoldBox", arguments: "ScaffoldBox_page");
              },
            ),
            CupertinoButton(
              child: Text(
                "Lifecycle",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed("Lifecycle", arguments: "Lifecycle_page");
              },
            ),
            RandomWordWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
