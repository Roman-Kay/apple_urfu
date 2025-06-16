
import 'package:json_annotation/json_annotation.dart';

part 'water_update_model.g.dart';


@JsonSerializable()
class ClientWaterRequest{
  ClientWaterRequest({
    this.dateStart,
    this.dateEnd
});

  String? dateEnd;
  String? dateStart;

  factory ClientWaterRequest.fromJson(Map<String, dynamic> json) => _$ClientWaterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientWaterRequestToJson(this);
}


@JsonSerializable()
class ClientWaterUpdateRequest{
  ClientWaterUpdateRequest({
    required this.val,
    this.dayNorm
});


  int? dayNorm;
  int val;

  factory ClientWaterUpdateRequest.fromJson(Map<String, dynamic> json) => _$ClientWaterUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientWaterUpdateRequestToJson(this);
}