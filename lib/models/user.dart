class User {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  String isverified;
  String image;
  String otp;
  Null address;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.isverified,
      this.image,
      this.otp,
      this.address,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    isverified = json['isverified'];
    image = json['image'];
    otp = json['otp'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['isverified'] = this.isverified;
    data['image'] = this.image;
    data['otp'] = this.otp;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
