
import 'package:json_annotation/json_annotation.dart';

part 'push_list_model.g.dart';

@JsonSerializable()
class PushListView {
  PushListView({
    this.list,
  });

  List<ListElement>? list;

  factory PushListView.fromJson(Map<String, dynamic> json) => _$PushListViewFromJson(json);

  Map<String, dynamic> toJson() => _$PushListViewToJson(this);

}

@JsonSerializable()
class ListElement {
  ListElement({
    this.text,
    this.authorId,
    this.timestamp,
    this.userId,
    this.readed,
    this.id,
    this.authorDisplayName,
  });

  String? text;
  String? authorId;
  int? timestamp;
  String? userId;
  bool? readed;
  String? id;
  String? authorDisplayName;

  factory ListElement.fromJson(Map<String, dynamic> json) => _$ListElementFromJson(json);

  Map<String, dynamic> toJson() => _$ListElementToJson(this);

}