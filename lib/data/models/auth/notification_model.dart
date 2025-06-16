
import 'package:json_annotation/json_annotation.dart';

part "notification_model.g.dart";


@JsonSerializable()
class NotificationRequest{
  NotificationRequest({
    this.notifications
});
  List<NotificationModelType>? notifications;

  factory NotificationRequest.fromJson(Map<String, dynamic> json) => _$NotificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationRequestToJson(this);
}


@JsonSerializable()
class NotificationModelType{
  NotificationModelType({
    this.type,
    this.subscribe
});

  bool? subscribe;
  NotificationTypeView? type;

  factory NotificationModelType.fromJson(Map<String, dynamic> json) => _$NotificationModelTypeFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelTypeToJson(this);

}


@JsonSerializable()
class NotificationTypeView{
  NotificationTypeView({
    this.type,
    this.name,
    this.desc,
    this.code,
    this.notificationTypeId
});

  String? code;
  String? desc;
  String? name;
  String? type;
  int? notificationTypeId;

  factory NotificationTypeView.fromJson(Map<String, dynamic> json) => _$NotificationTypeViewFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationTypeViewToJson(this);
}