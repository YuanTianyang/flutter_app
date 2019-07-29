class User{

  int     id;
  String  userName;
  int     age;
  String  hobby;
  String  phone;
  String  address;

  User(int id, String userName, int age, String hobby, String phone, String address){
    this.id = id;
    this.userName = userName;
    this.age = age;
    this.hobby = hobby;
    this.phone = phone;
    this.address = address;
  }

  //get
  int getId() {
    return id;
  }

  String getUserName() {
    return userName;
  }

  int getAge() {
    return age;
  }

  String getHobby() {
    return hobby;
  }

  String getPhone() {
    return phone;
  }

  String getAddress() {
    return address;
  }
  //set
  void setId(int id) {
    this.id = id;
  }

  void setUserName(String userName) {
    this.userName = userName;
  }

  void setAge(int age) {
    this.age = age;
  }

  void setHobby(String hobby) {
    this.hobby = hobby;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setAddress(String address) {
    this.address = address;
  }
}