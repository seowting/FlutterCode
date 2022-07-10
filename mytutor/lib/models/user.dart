class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phoneno;
  String? homeaddress;
  String? cart;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phoneno,
      this.homeaddress,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phoneno = json['phoneno'];
    homeaddress = json['homeaddress'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phoneno'] = phoneno;
    data['homeaddress'] = homeaddress;
    data['cart'] = cart.toString();
    return data;
  }
}
