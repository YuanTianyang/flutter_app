class User{

  int     id;
  String  userName;
  int     age;
  String  hobby;
  String  phone;
  String  address;

  User({this.id,this.userName,this.age,this.hobby,this.phone,this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['id'],
      userName: json['userName'],
      age: json['age'],
      hobby: json['hobby'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}