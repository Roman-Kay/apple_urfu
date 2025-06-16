
import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class CreateOrderResponse{
  CreateOrderResponse({
    this.code,
    this.message,
    this.formUrl,
    this.orderId
});

  int? code;

  @JsonKey(
    name: 'formUrl',
  )
  String? formUrl;
  String? message;

  @JsonKey(
    name: 'orderId',
  )
  int? orderId;

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) => _$CreateOrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class CreateOrderRequest{
  CreateOrderRequest({
    this.description,
    this.amount,
    this.failUrl,
    this.feeInput,
    this.returnUrl
});

  int? amount;
  String? description;

  @JsonKey(
    name: 'failUrl',
  )
  String? failUrl;

  @JsonKey(
    name: 'feeInput',
  )
  int? feeInput;

  @JsonKey(
    name: 'returnUrl',
  )
  String? returnUrl;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}