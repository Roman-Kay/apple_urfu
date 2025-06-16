
import 'package:json_annotation/json_annotation.dart';

part 'q_type_view.g.dart';

@JsonSerializable()
class QTypeView {
  QTypeView({
    this.id,
    this.title,
    this.firstStep
  });

  final int? id;
  final String? title;
  @JsonKey(name: 'first_step')
  final int? firstStep;

  factory QTypeView.fromJson(Map<String, dynamic> json) => _$QTypeViewFromJson(json);

  Map<String, dynamic> toJson() => _$QTypeViewToJson(this);

}
