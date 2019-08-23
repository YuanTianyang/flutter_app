import 'package:mysql1/mysql1.dart';
class CommonUtils  {

  static final String HOST = '192.168.100.134';

  static final int PORT = 3306;

  static final String USER = 'root';

  static final String PASSWORD = '449534640';

  static final String DB = 'test_app';

  static MySqlConnection Connection;

  static bool IsOpenDB = false;

}