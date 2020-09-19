// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    uid: json['uid'],
    name: json['name'],
    profilePhoto: json['profilePhoto'],
    email: json['email'],
    password: json['password'],
    userType: json['userType'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'profilePhoto': instance.profilePhoto,
      'userType': instance.userType,
    };
