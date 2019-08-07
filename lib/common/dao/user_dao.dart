import 'package:flutter_app/common/utils/common_utils.dart';
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
      User user;
      for(var row in results){
        user = new User(id:row[0], userName:row[1], age:row[2], hobby:row[3], phone:row[4], address:row[5]);
      }
      return user;
    }else{
      return null;
    }

  }


  Future<List<User>> getAllUser(MySqlConnection conn, int page, int limit) async {

    if(CommonUtils.IsOpenDB && null != conn){
      var results = await conn.query('SELECT id,user_name,age,hobby,phone,address FROM `user`');
      List<User> userList = new List();
      if(null != results){
        for(var row in results){
          User user = new User(id:row[0], userName:row[1], age:row[2], hobby:row[3], phone:row[4], address:row[5]);
          userList.add(user);
        }
        return userList;
      }else{
        return null;
      }
    }
  }
}