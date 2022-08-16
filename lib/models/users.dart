

class UserModel
{
  final String? id;
  final String? fname;
  final String? lname;
  final String? email;
  final String? password;

  UserModel({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json)
  {
    return UserModel(
      id: json['UID'].toString(),
      fname: json['FirstName'].toString(),
      lname: json['LastName'].toString(),
      email: json['Email'].toString(),
    );
  }
}