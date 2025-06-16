
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'achieves_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertAchievesResponse{
  ExpertAchievesResponse({
    required this.code,
    this.message,
    this.achieves
});
  int code;
  String? message;
  List<ExpertAchievesView>? achieves;

  factory ExpertAchievesResponse.fromJson(Map<String, dynamic> json) => _$ExpertAchievesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertAchievesResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertAchievesView{
  ExpertAchievesView({
    this.educationDocBase64,
    this.update,
    this.create,
    this.lastName,
    this.firstName,
    this.expertId,
    this.achieveDesc,
    this.expertAchieveId
});

  @JsonKey(
    name: 'achieveDesc',
  )
  String? achieveDesc;
  String? create;

  @JsonKey(
    name: 'educationDocBase64',
  )
  FileView? educationDocBase64;

  @JsonKey(
    name: 'expertAchieveId',
  )
  int? expertAchieveId;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;
  String? update;

  factory ExpertAchievesView.fromJson(Map<String, dynamic> json) => _$ExpertAchievesViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertAchievesViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertAchievesRequest{
  ExpertAchievesRequest({
    this.expertAchieveId,
    this.achieveDesc,
    this.doc
});

  @JsonKey(
    name: 'achieveDesc',
  )
  String? achieveDesc;
  ImageView? doc;

  @JsonKey(
    name: 'expertAchieveId',
  )
  int? expertAchieveId;

  factory ExpertAchievesRequest.fromJson(Map<String, dynamic> json) => _$ExpertAchievesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertAchievesRequestToJson(this);

}