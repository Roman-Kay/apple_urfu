
import 'package:json_annotation/json_annotation.dart';

part 'client_expert_auth.g.dart';


@JsonSerializable()
class AddClientExpertRequest{
  AddClientExpertRequest({
    this.firstName,
    this.height,
    this.weight,
    this.birthDate,
    this.genderId,
    this.lastName,
    this.phone
});

  int? weight;
  int? height;
  String? phone;
  int? genderId;
  String? firstName;
  String? lastName;
  String? birthDate;


  factory AddClientExpertRequest.fromJson(Map<String, dynamic> json) => _$AddClientExpertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddClientExpertRequestToJson(this);

}