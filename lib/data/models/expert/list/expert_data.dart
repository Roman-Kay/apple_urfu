
import 'package:garnetbook/data/models/expert/profile/achieves_model.dart';
import 'package:garnetbook/data/models/expert/profile/education_model.dart';
import 'package:garnetbook/data/models/expert/profile/experience_model.dart';
import 'package:garnetbook/data/models/expert/profile/profile_model.dart';
import 'package:garnetbook/data/models/expert/tariffs/tarrifs_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expert_data.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertFullCardResponse{
  ExpertFullCardResponse({
    this.message,
    this.code,
    this.fullCard
});

  int? code;
  String? message;

  @JsonKey(
    name: 'fullCard',
  )
  ExpertFullCardView? fullCard;

  factory ExpertFullCardResponse.fromJson(Map<String, dynamic> json) => _$ExpertFullCardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertFullCardResponseToJson(this);
}


@JsonSerializable()
class ExpertFullCardView{
  ExpertFullCardView({
    this.firstName,
    this.lastName,
    this.experiences,
    this.educations,
    this.achieves,
    this.profile,
    this.tariffs,
    this.avatarBase64
});

  @JsonKey(
    name: 'avatarBase64',
  )
  FileView? avatarBase64;

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;
  List<ExpertTariffView>? tariffs;
  ExpertProfileView? profile;

  List<ExpertAchievesView>? achieves;
  List<ExpertEducationView>? educations;
  List<ExpertExperienceView>? experiences;

  factory ExpertFullCardView.fromJson(Map<String, dynamic> json) => _$ExpertFullCardViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertFullCardViewToJson(this);
}









