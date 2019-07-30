import 'package:mysql1/mysql1.dart';
import 'package:flutter_app/common/model/user.dart';


class UserDao {

  Future<int> addUser(MySqlConnection conn,User user) async {
    var results = await conn.query('INSERT INTO user (user_name, age, hobby, phone, address) VALUES (?, ?, ?, ?, ?)',[user.userName,user.age,user.hobby,user.phone,user.address]);
    if(0 < results.affectedRows){
      return results.insertId;
    }else{
      return -1;
    }
  }

  Future<int> deleteUser(MySqlConnection conn,User user) async {

    var results = await conn.query('DELETE FROM user WHERE id=?',[user.id]);
    if(0 < results.affectedRows){
      return results.affectedRows;
    }else{
      return -1;
    }
  }

  Future<User> updateUser(MySqlConnection conn,User user) async {

    var results = await conn.query('UPDATE user SET user_name = ?, age = ?, hobby = ?, phone = ?, address = ? WHERE id = ?',[user.userName,user.age,user.hobby,user.phone,user.address,user.id]);
    if(0 < results.affectedRows){
      var newUser = getUserById(conn, user);
      return newUser;
    }else{
      return null;
    }
  }

  Future<User> getUserById(MySqlConnection conn,User user) async {

    var results = await conn.query('SELECT id,user_name,age,hobby,phone,address FROM `user` WHERE id = ?',[user.id]);
    if(null != results){
      for(var row in results){
        User user = new User(row[0], row[1], row[2], row[3], row[4],row[5]);
      }
      return user;
    }else{
      return null;
    }

  }


  Future<List<User>> getAllUser(MySqlConnection conn, int page, int limit) async {

    var results = await conn.query('SELECT id,user_name,age,hobby,phone,address FROM `user`');
    List<User> userList = new List();
    if(null != results){
      for(var row in results){
        User user = new User(row[0], row[1], row[2], row[3], row[4],row[5]);
        userList.add(user);
      }
      return userList;
    }else{
      return null;
    }

  }
}