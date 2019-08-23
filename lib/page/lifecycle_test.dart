import 'package:flutter/material.dart';

class LifecyclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new LifecycleAppPage(),
    );
  }
}

class LifecycleAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LifecycleAppPageState('------------------构造函数------------------');//用于处理StatefulWidget控件生命周期中的各个状态的事件
  }
}

class _LifecycleAppPageState extends State<LifecycleAppPage>
    with WidgetsBindingObserver {
  String str;

  int count = 0;

  _LifecycleAppPageState(this.str);

  @override
  void initState() {
    super.initState();
    print(str);
    print('------------------initState------------------');//初始化一些变量，调起异步网络请求获取数据，用于获取一次性资源（监听等）
    WidgetsBinding.instance.addObserver(this);//添加监听
  }

  @override
  void reassemble(){
    print('------------------reassemble------------------');//在热重载时调用（重新组装）
    super.reassemble();
  }

  @override
  void didChangeDependencies() {
    print('------------------didChangeDependencies------------------');//state对象的依赖关系发生变化时调用，当调用initState后会立即调用这个方法，这个方法是在State对象被创建好了但没有准备好构建（build）的时候调用的
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(LifecycleAppPage oldWidget) {
    print('------------------didUpdateWidget------------------');//热重载,横竖屏切换（widget的配置发生变化时，必定调用build）
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print('------------------deactivate------------------');//吊销、销毁组件（暂时从视图树种移除）
    super.deactivate();
  }

  @override
  void dispose() {
    print('------------------dispose------------------');//state被永久的从视图树种移除（最终的资源释放，取消监听）
    WidgetsBinding.instance.removeObserver(this);//移除监听
    super.dispose();
  }

//任务栏切换
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive://处在并不活动状态，无法处理用户响应
        print('------------------AppLifecycleState.inactive------------------');
        break;
      case AppLifecycleState.paused://后台运行状态 用户不可见、不响应用户状态
        print('------------------AppLifecycleState.paused------------------');
        break;
      case AppLifecycleState.resumed://不可见并不能响应用户的输入，但是在后台继续活动中
        //获取剪切板内容
        //解析内容
        print('------------------AppLifecycleState.resumed------------------');
        break;
      case AppLifecycleState.suspending://悬浮
        print('------------------AppLifecycleState.suspending------------------');
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    print('------------------build------------------');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('lifecycle 学习'),
        centerTitle: true,
      ),
      body: new OrientationBuilder(
        builder: (context, orientation) {
          return new Center(
            child: new Text(
              '当前计数值：$count',
              style: new TextStyle(
                  color: orientation == Orientation.portrait
                      ? Colors.blue
                      : Colors.red),
            ),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Text('click'),
          onPressed: () {
            count++;
            setState(() {});
      }),
    );
  }
}

