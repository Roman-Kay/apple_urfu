
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserResponse{
  UserResponse({
    this.user,
    this.code,
    this.message
});

  int? code;
  String? message;
  UserView? user;

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}