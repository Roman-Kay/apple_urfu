
import 'package:json_annotation/json_annotation.dart';

part 'analysis.g.dart';


@JsonSerializable()
class ClientTestDto{
  ClientTestDto({
    this.clientId,
    this.expertId,
    this.testDate,
    this.medicalLaboratoryId,
    this.medicalLaboratoryName,
    this.researchResult,
    this.resultsDecrypted,
    this.testName,
    this.familyProfileId
});

  int? clientId;
  int? expertId;
  int? medicalLaboratoryId;
  String? medicalLaboratoryName;
  bool? resultsDecrypted;
  String? testDate;
  String? testName;
  List<ResearchResultDto>? researchResult;
  FilePdf? file;
  int? familyProfileId;

  factory ClientTestDto.fromJson(Map<String, dynamic> json) => _$ClientTestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTestDtoToJson(this);
}


@JsonSerializable()
class ResearchResultDto{
  ResearchResultDto({
    this.analysisCode,
    this.analysisDesc,
    this.cause,
    this.mark,
    this.norma,
    this.specialMarks
});

  String? analysisCode;
  String? analysisDesc;
  String? cause;
  String? mark;
  bool? norma;
  String? specialMarks;

  factory ResearchResultDto.fromJson(Map<String, dynamic> json) => _$ResearchResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResearchResultDtoToJson(this);
}


@JsonSerializable()
class FilePdf{
  FilePdf({
    this.base64,
    this.format
});

  String? base64;
  String? format;

  factory FilePdf.fromJson(Map<String, dynamic> json) => _$FilePdfFromJson(json);
  Map<String, dynamic> toJson() => _$FilePdfToJson(this);
}


@JsonSerializable()
class ClientTestShort{
  ClientTestShort({
    this.clientId,
    this.id,
    this.medicalLaboratoryId,
    this.testName,
    this.testDate,
    this.norma,
    this.resultsDecrypted,
    this.expertId,
    this.medicalLaboratoryName,
    this.familyProfileId
});

  int? clientId;
  int? expertId;
  int? id;
  int? medicalLaboratoryId;
  String? medicalLaboratoryName;
  bool? norma;
  bool? resultsDecrypted;
  String? testDate;
  String? testName;
  int? familyProfileId;

  factory ClientTestShort.fromJson(Map<String, dynamic> json) => _$ClientTestShortFromJson(json);
  Map<String, dynamic> toJson() => _$ClientTestShortToJson(this);
}