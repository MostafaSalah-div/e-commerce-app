import 'package:equatable/equatable.dart';

class UserModel extends Equatable {final int id;
final String username;
final String email;
final String firstName;
final String lastName;
final String gender;
final String image;
final String token;
final String? password; // Added for local matching

const UserModel({
  required this.id,
  required this.username,
  required this.email,
  required this.firstName,
  required this.lastName,
  required this.gender,
  required this.image,
  required this.token,
  this.password,
});

factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] ?? 0,
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    gender: json['gender'] ?? '',
    image: json['image'] ?? '',
    token: json['accessToken'] ?? json['token'] ?? '',
    password: json['password'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender,
    'image': image,
    'token': token,
    'password': password,
  };
}

@override
List<Object?> get props => [id, username, email, firstName, lastName, gender, image, token, password];
}