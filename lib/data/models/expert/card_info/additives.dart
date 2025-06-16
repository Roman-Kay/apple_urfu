
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:json_annotation/json_annotation.dart';

part "additives.g.dart";


@JsonSerializable(fieldRename: FieldRename.snake)
class CardClientAdditivesResponse{
  CardClientAdditivesResponse({
    this.message,
    this.code,
    this.additives
});

  Map<String, List<CardClientAdditivesView>>? additives;
  int? code;
  String? message;

  factory CardClientAdditivesResponse.fromJson(Map<String, dynamic> json) => _$CardClientAdditivesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CardClientAdditivesResponseToJson(this);

}


@JsonSerializable()
class CardClientAdditivesView{
  CardClientAdditivesView({
    this.start,
    this.id,
    this.statuses,
    this.expert,
    this.name,
    this.create,
    this.finish
});

  String? create;
  ExpertShortCardView? expert;
  int? id;
  String? start;
  String? name;
  AdditiveStatusesView2? statuses;
  String? finish;

  factory CardClientAdditivesView.fromJson(Map<String, dynamic> json) => _$CardClientAdditivesViewFromJson(json);
  Map<String, dynamic> toJson() => _$CardClientAdditivesViewToJson(this);
}