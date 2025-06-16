
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part "client_short_card.g.dart";

@JsonSerializable()
class ClientShortCardView{
  ClientShortCardView({
    this.clientId,
    this.email,
    this.familyStatus,
    this.firstName,
    this.gender,
    this.lastName,
    this.phone
  });


  int? clientId;
  String? email;
  String? familyStatus;
  String? firstName;
  GenderView? gender;
  String? lastName;
  String? phone;


  factory ClientShortCardView.fromJson(Map<String, dynamic> json) => _$ClientShortCardViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientShortCardViewToJson(this);

}