
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'education_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertEducationRequest{
  ExpertEducationRequest({

    this.educationDesc,
    this.educationName,
    this.educationYear,
    this.expertEducationId,
    this.doc
});

  @JsonKey(
    name: 'educationDesc',
  )
  String? educationDesc;

  @JsonKey(
    name: 'educationName',
  )
  String? educationName;

  @JsonKey(
    name: 'educationYear',
  )
  int? educationYear;

  @JsonKey(
    name: 'expertEducationId',
  )
  int? expertEducationId;

  ImageView? doc;

  factory ExpertEducationRequest.fromJson(Map<String, dynamic> json) => _$ExpertEducationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertEducationRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertEducationResponse{
  ExpertEducationResponse({
    required this.code,
    this.message,
    this.educations
});

  int code;
  String? message;
  List<ExpertEducationView>? educations;

  factory ExpertEducationResponse.fromJson(Map<String, dynamic> json) => _$ExpertEducationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertEducationResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertEducationView{
  ExpertEducationView({
    this.expertEducationId,
    this.educationYear,
    this.educationName,
    this.educationDesc,
    this.expertId,
    this.firstName,
    this.lastName,
    this.create,
    this.update,
    this.educationDocBase64
});

  String? create;

  @JsonKey(
    name: 'educationDesc',
  )
  String? educationDesc;

  @JsonKey(
    name: 'educationDocBase64',
  )
  FileView? educationDocBase64;

  @JsonKey(
    name: 'educationName',
  )
  String? educationName;

  @JsonKey(
    name: 'educationYear',
  )
  int? educationYear;

  @JsonKey(
    name: 'expertEducationId',
  )
  int? expertEducationId;

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

  factory ExpertEducationView.fromJson(Map<String, dynamic> json) => _$ExpertEducationViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertEducationViewToJson(this);
}