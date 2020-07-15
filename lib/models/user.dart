import 'package:json_annotation/json_annotation.dart';


part 'user.g.dart';

@JsonSerializable()
class User {
  String uid;
  String email;
  String password;
  String name;
  String profilePhoto;

  User(
      {this.uid,
      this.name,
      this.profilePhoto,
      this.email,
      this.password});

  factory User.fromJson(Map json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);


}


// phone  