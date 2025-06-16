

import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'protocols_model.g.dart';


@JsonSerializable()
class ProtocolView{
  ProtocolView({
    this.create,
    this.id,
    this.expertId,
    this.clientId,
    this.additivesViews,
    this.protocolDate,
    this.protocolName
  });

  int? clientId;
  String? create;
  int? expertId;
  int? id;
  String? protocolDate;
  String? protocolName;
  List<ClientAdditivesView>? additivesViews;


  factory ProtocolView.fromJson(Map<String, dynamic> json) => _$ProtocolViewFromJson(json);
  Map<String, dynamic> toJson() => _$ProtocolViewToJson(this);
}

@JsonSerializable()
class ProtocolCreate{
  ProtocolCreate({
    this.protocolName,
    this.protocolDate,
    this.clientId,
    this.expertId
});

  int? clientId;
  int? expertId;
  String? protocolDate;
  String? protocolName;

  factory ProtocolCreate.fromJson(Map<String, dynamic> json) => _$ProtocolCreateFromJson(json);
  Map<String, dynamic> toJson() => _$ProtocolCreateToJson(this);
}