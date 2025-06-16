

import 'package:json_annotation/json_annotation.dart';

part 'tarrifs_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertTariffCreateRequest{
  ExpertTariffCreateRequest({
    this.expertTariffId,
    this.expertTariffName,
    this.expertTariffVal,
    this.description
});

  String? description;

  @JsonKey(
    name: 'expertTariffId',
  )
  int? expertTariffId;

  @JsonKey(
    name: 'expertTariffName',
  )
  String? expertTariffName;

  @JsonKey(
    name: 'expertTariffVal',
  )
  String? expertTariffVal;

  factory ExpertTariffCreateRequest.fromJson(Map<String, dynamic> json) => _$ExpertTariffCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertTariffCreateRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertTariffResponse{
  ExpertTariffResponse({
    required this.code,
    this.message,
    this.expertTariffs
});

  int code;
  String? message;

  @JsonKey(
    name: 'expertTariffs',
  )
  List<ExpertTariffView>? expertTariffs;

  factory ExpertTariffResponse.fromJson(Map<String, dynamic> json) => _$ExpertTariffResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertTariffResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertTariffView{
  ExpertTariffView({
    this.expertTariffId,
    this.expertId,
    this.lastName,
    this.firstName,
    this.tariffName,
    this.tariffVal,
    this.description
});

  String? description;
  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'expertTariffId',
  )
  int? expertTariffId;

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;

  @JsonKey(
    name: 'tariffName',
  )
  String? tariffName;

  @JsonKey(
    name: 'tariffVal',
  )
  String? tariffVal;

  factory ExpertTariffView.fromJson(Map<String, dynamic> json) => _$ExpertTariffViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertTariffViewToJson(this);
}