
import 'package:json_annotation/json_annotation.dart';

part 'sms_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class SMSSendResponse{
  SMSSendResponse({
    this.id,
    this.text,
    this.message,
    this.number,
    this.code,
    this.status,
    this.userId,
    this.sign,
    this.cost,
    this.dateAnswer,
    this.dateSend,
    this.extendStatus,
    this.verificationCode
});

  int? code;
  num? cost;

  @JsonKey(
    name: 'dateAnswer',
  )
  String? dateAnswer;

  @JsonKey(
    name: 'dateSend',
  )
  String? dateSend;

  @JsonKey(
    name: 'extendStatus',
  )
  String? extendStatus;

  @JsonKey(
    name: 'verificationCode',
  )
  String? verificationCode;

  int? id;
  String? message;
  String? number;
  String? sign;
  int? status;
  String? text;

  @JsonKey(
    name: 'userId',
  )
  int? userId;

  factory SMSSendResponse.fromJson(Map<String, dynamic> json) => _$SMSSendResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SMSSendResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class SMSStatusResponse{
  SMSStatusResponse({
    this.extendStatus,
    this.dateSend,
    this.dateAnswer,
    this.status,
    this.code,
    this.message,
    this.id,
    this.dateCreate
});

  int? code;

  @JsonKey(
    name: 'dateAnswer',
  )
  String? dateAnswer;

  @JsonKey(
    name: 'dateCreate',
  )
  String? dateCreate;

  @JsonKey(
    name: 'dateSend',
  )
  String? dateSend;

  @JsonKey(
    name: 'extendStatus',
  )
  String? extendStatus;
  int? id;
  String? message;
  int? status;

  factory SMSStatusResponse.fromJson(Map<String, dynamic> json) => _$SMSStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SMSStatusResponseToJson(this);
}