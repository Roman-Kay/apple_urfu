
import 'package:json_annotation/json_annotation.dart';

part 'analysis_request.g.dart';


@JsonSerializable()
class CreateAnalysisData{
  CreateAnalysisData({
    this.testName,
    this.medicalLaboratoryId,
    this.expertId,
    this.clientId,
    this.file,
    this.date,
    this.dateBirthClient,
    this.gander,
    this.decrypt,
    this.familyProfileId
});

  int? clientId;
  String? date;
  String? dateBirthClient;
  int? expertId;
  Document? file;
  int? gander;
  int? medicalLaboratoryId;
  String? testName;
  bool? decrypt;
  int? familyProfileId;

  factory CreateAnalysisData.fromJson(Map<String, dynamic> json) => _$CreateAnalysisDataFromJson(json);
  Map<String, dynamic> toJson() => _$CreateAnalysisDataToJson(this);
}


@JsonSerializable()
class Document{
  Document({
    this.format,
    this.base64
});

  String? base64;
  String? format;

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}


@JsonSerializable()
class HeaderResponse{
  HeaderResponse({
    this.id,
    this.message,
    this.description,
    this.successfully
});

  String? description;
  int? id;
  String? message;
  bool? successfully;

  factory HeaderResponse.fromJson(Map<String, dynamic> json) => _$HeaderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HeaderResponseToJson(this);
}