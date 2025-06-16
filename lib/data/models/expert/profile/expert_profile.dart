
import 'package:json_annotation/json_annotation.dart';

part 'expert_profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertProfileCreateRequest{
  ExpertProfileCreateRequest({
    this.traetmentCase,
    this.receptionType,
    this.categoryId,
    this.position,
    this.address,
    this.experience,
    this.userId,
    this.expertId
});

  String? address;

  @JsonKey(
    name: 'categoryId',
  )
  int? categoryId;
  int? experience;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;
  String? position;

  @JsonKey(
    name: 'receptionType',
  )
  String? receptionType;

  @JsonKey(
    name: 'traetmentCase',
  )
  String? traetmentCase;

  @JsonKey(
    name: 'userId',
  )
  int? userId;

  factory ExpertProfileCreateRequest.fromJson(Map<String, dynamic> json) => _$ExpertProfileCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertProfileCreateRequestToJson(this);
}