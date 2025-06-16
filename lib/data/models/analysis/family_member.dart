import 'package:json_annotation/json_annotation.dart';

part 'family_member.g.dart';

@JsonSerializable()
class FamilyProfile{
  FamilyProfile({
    this.name,
    this.id,
    this.clientId,
    this.birthDate,
    this.genderId
});

  String? birthDate;
  int? clientId;
  int? genderId;
  int? id;
  String? name;

  factory FamilyProfile.fromJson(Map<String, dynamic> json) => _$FamilyProfileFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyProfileToJson(this);
}