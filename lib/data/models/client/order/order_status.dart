

import 'package:json_annotation/json_annotation.dart';

part 'order_status.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class OrderStatusResponse{
  OrderStatusResponse({
    this.message,
    this.code,
    this.orderStatus,
    this.orderStatusDesc
});

  int? code;
  String? message;

  @JsonKey(
    name: 'orderStatus',
  )
  int? orderStatus;

  @JsonKey(
    name: 'orderStatusDesc',
  )
  int? orderStatusDesc;

  factory OrderStatusResponse.fromJson(Map<String, dynamic> json) => _$OrderStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStatusResponseToJson(this);
}