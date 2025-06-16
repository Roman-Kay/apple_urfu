
import 'package:garnetbook/data/models/client/profile/client_profile_model.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/data/models/expert/client_claims/claims_model.dart';
import 'package:json_annotation/json_annotation.dart';

part "card_info.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class CardClientInfoResponse{
  CardClientInfoResponse({
    this.code,
    this.message,
    this.target,
    this.profile
});

  int? code;
  String? message;
  ClientProfileView? profile;
  List<ClientTargetsView>? target;

  factory CardClientInfoResponse.fromJson(Map<String, dynamic> json) => _$CardClientInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CardClientInfoResponseToJson(this);
}


