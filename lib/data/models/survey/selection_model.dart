
import 'package:json_annotation/json_annotation.dart';

part 'selection_model.g.dart';

@JsonSerializable()
class SelectionListView {
  SelectionListView({
    required this.id,
    required this.title,
  });

  final int? id;
  final String? title;

  factory SelectionListView.fromJson(Map<String, dynamic> json) => _$SelectionListViewFromJson(json);

  Map<String, dynamic> toJson() => _$SelectionListViewToJson(this);

}

@JsonSerializable()
class SelectionView {
  SelectionView({
    required this.id,
    required this.qtypes,
    required this.title,
  });

  final int? id;
  final List<String>? qtypes;
  final String? title;

  factory SelectionView.fromJson(Map<String, dynamic> json) => _$SelectionViewFromJson(json);

  Map<String, dynamic> toJson() => _$SelectionViewToJson(this);

}
