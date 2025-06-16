
import 'package:json_annotation/json_annotation.dart';

part 'recovery_password.g.dart';


@JsonSerializable()
class RecoveryPasswordRequest{
  RecoveryPasswordRequest({
    required this.phone,
    required this.smsId,
    required this.verificationCode
});

  String phone;
  int smsId;
  String verificationCode;

  factory RecoveryPasswordRequest.fromJson(Map<String, dynamic> json) => _$RecoveryPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RecoveryPasswordRequestToJson(this);
}

