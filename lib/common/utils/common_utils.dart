import 'dart:async';
import 'package:mysql1/mysql1.dart';
class CommonUtils  {

  static final String HOST = '192.168.100.134';

  static final int PORT = 3306;

  static final String USER = 'root';

  static final String PASSWORD = '449534640';

  static final String DB = 'test_app';

  static MySqlConnection Connection;

  static bool MySqlIsOpen;

  var readyCompleter = Completer();
  Future get ready => readyCompleter.future;

  NewsDbProvider() {
    initMySqlConnection().then((_) {
      // mark the provider ready when init completes
      readyCompleter.complete();
    });
  }

  static Future initMySqlConnection() async {
    var settings = new ConnectionSettings(
      host: '192.168.100.134',
      port: 3306,
      user: 'root',
      password: '449534640',
      db: 'test_app',
    );
    print("opening mysql");
    var conn = await MySqlConnection.connect(settings);
    print("opened mysql");
  }
}