
import 'package:json_annotation/json_annotation.dart';

part 'experience_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertExperienceRequest{
  ExpertExperienceRequest({
    this.expertExperienceId,
    this.experiencePeriod,
    this.experienceDesc,
});

  @JsonKey(
    name: 'experienceDesc',
  )
  String? experienceDesc;

  @JsonKey(
    name: 'experiencePeriod',
  )
  String? experiencePeriod;

  @JsonKey(
    name: 'expertExperienceId',
  )
  int? expertExperienceId;

  factory ExpertExperienceRequest.fromJson(Map<String, dynamic> json) => _$ExpertExperienceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertExperienceRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertExperienceResponse{
  ExpertExperienceResponse({
    required this.code,
    this.message,
    this.experiences
});

  int code;
  String? message;
  List<ExpertExperienceView>? experiences;

  factory ExpertExperienceResponse.fromJson(Map<String, dynamic> json) => _$ExpertExperienceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertExperienceResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertExperienceView{
  ExpertExperienceView({
    this.update,
    this.create,
    this.lastName,
    this.firstName,
    this.expertId,
    this.experienceDesc,
    this.experiencePeriod,
    this.expertExperienceId
});

  String? create;

  @JsonKey(
    name: 'experienceDesc',
  )
  String? experienceDesc;

  @JsonKey(
    name: 'experiencePeriod',
  )
  String? experiencePeriod;

  @JsonKey(
    name: 'expertExperienceId',
  )
  int? expertExperienceId;

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

  factory ExpertExperienceView.fromJson(Map<String, dynamic> json) => _$ExpertExperienceViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertExperienceViewToJson(this);
}