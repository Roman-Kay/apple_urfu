
import 'package:json_annotation/json_annotation.dart';

part "file_models.g.dart";

@JsonSerializable()
class MessageFileModels{
  MessageFileModels({
    required this.name,
    required this.data
});

  String name;
  String data;

  factory MessageFileModels.fromJson(Map<String, dynamic> json) => _$MessageFileModelsFromJson(json);
  Map<String, dynamic> toJson() => _$MessageFileModelsToJson(this);
}


@JsonSerializable()
class MessageFileResponse{
  MessageFileResponse({
    this.id
});

  String? id;

  factory MessageFileResponse.fromJson(Map<String, dynamic> json) => _$MessageFileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MessageFileResponseToJson(this);
}



@JsonSerializable()
class MessageFileData{
  MessageFileData({
    this.data,
    this.name,
    this.authorId
});

  String? name;
  String? authorId;
  String? data;

  factory MessageFileData.fromJson(Map<String, dynamic> json) => _$MessageFileDataFromJson(json);
  Map<String, dynamic> toJson() => _$MessageFileDataToJson(this);
}