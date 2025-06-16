

import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clients_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertClientsResponse{
  ExpertClientsResponse({
    required this.code,
    this.message,
    this.expertClients
});

  int code;
  String? message;

  @JsonKey(
    name: 'expertClients',
  )
  List<ExpertClientsView>? expertClients;

  factory ExpertClientsResponse.fromJson(Map<String, dynamic> json) => _$ExpertClientsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertClientsResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertClientsView{
  ExpertClientsView({
    this.clientFirstName,
    this.clientLastName,
    this.clientId,
    this.expertId,
    this.clientPosition,
    this.clientInfo,
    this.clientAge,
    this.reason
});

  @JsonKey(
    name: 'clientAge',
  )
  int? clientAge;

  @JsonKey(
    name: 'clientFirstName',
  )
  String? clientFirstName;

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'clientLastName',
  )
  String? clientLastName;

  @JsonKey(
    name: 'clientPosition',
  )
  String? clientPosition;
  String? reason;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'clientInfo',
  )
  ClientInformationView? clientInfo;

  factory ExpertClientsView.fromJson(Map<String, dynamic> json) => _$ExpertClientsViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertClientsViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientInformationView{
  ClientInformationView({
    this.weight,
    this.target,
    this.height,
    this.clientAvatarBase64,
    this.targets
});

  @JsonKey(
    name: 'clientAvatarBase64',
  )
  FileView? clientAvatarBase64;
  int? height;
  String? target;
  int? weight;
  List<ClientTargetsView>? targets;

  factory ClientInformationView.fromJson(Map<String, dynamic> json) => _$ClientInformationViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientInformationViewToJson(this);

}
