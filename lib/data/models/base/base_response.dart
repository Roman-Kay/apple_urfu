

import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class BaseResponse{

  BaseResponse({
    this.code,
    this.message,
    this.id,
    this.token
  });

  int? code;
  String? message;
  String? token;
  int? id;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);

}