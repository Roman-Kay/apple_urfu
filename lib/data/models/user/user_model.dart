
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserView {
  UserView({
    this.id,
    this.gender,
    this.avatarBase64,
    this.firstName,
    this.birthDate,
    this.email,
    this.lastName,
    this.role,
    this.token,
    this.phone,
    this.profileId
});

  @JsonKey(
    name: 'profileId',
  )
  int? profileId;

  @JsonKey(
    name: 'avatarBase64',
  )
  FileView? avatarBase64;

  @JsonKey(
    name: 'birthDate',
  )
  String? birthDate;
  String? email;

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;
  GenderView? gender;
  int? id;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;
  RoleView? role;
  String? token;
  String? phone;

  factory UserView.fromJson(Map<String, dynamic> json) => _$UserViewFromJson(json);
  Map<String, dynamic> toJson() => _$UserViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class GenderView{
  GenderView({
    this.name,
    this.id
});

  int? id;
  String? name;

  factory GenderView.fromJson(Map<String, dynamic> json) => _$GenderViewFromJson(json);
  Map<String, dynamic> toJson() => _$GenderViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class RoleView{
  RoleView({
    this.name,
    this.id
  });

  int? id;
  String? name;

  factory RoleView.fromJson(Map<String, dynamic> json) => _$RoleViewFromJson(json);
  Map<String, dynamic> toJson() => _$RoleViewToJson(this);
}

