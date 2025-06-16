

import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertProfileResponse{
  ExpertProfileResponse({
    required this.code,
    this.message,
    this.expertProfile
});

  int code;
  String? message;

  @JsonKey(
    name: 'expertProfile',
  )
  ExpertProfileView? expertProfile;

  factory ExpertProfileResponse.fromJson(Map<String, dynamic> json) => _$ExpertProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertProfileResponseToJson(this);
}


@JsonSerializable()
class ExpertProfileView{
  ExpertProfileView({
    this.id,
    this.userId,
    this.categoryId,
    this.position,
    this.address,
    this.experience,
    this.receptionType,
    this.traetmentCase,
    this.user
});

  String? address;
  int? experience;
  int? id;
  String? position;
  String? receptionType;
  String? traetmentCase;
  int? userId;
  UserView? user;
  ReferenceExpertCategoriesView? categoryId;



  factory ExpertProfileView.fromJson(Map<String, dynamic> json) => _$ExpertProfileViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertProfileViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ReferenceExpertCategoriesView{
  ReferenceExpertCategoriesView({
    this.id,
    this.name
});

  int? id;
  String? name;

  factory ReferenceExpertCategoriesView.fromJson(Map<String, dynamic> json) => _$ReferenceExpertCategoriesViewFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceExpertCategoriesViewToJson(this);
}