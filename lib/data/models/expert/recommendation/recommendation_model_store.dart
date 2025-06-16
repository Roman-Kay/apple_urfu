
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommendation_model_store.g.dart';


@JsonSerializable()
class RecommendationItemStore{
  RecommendationItemStore(this.recommendationList);

  List<RecommendationItem> recommendationList;

  factory RecommendationItemStore.fromJson(Map<String, dynamic> json) => _$RecommendationItemStoreFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationItemStoreToJson(this);
}


@JsonSerializable()
class RecommendationItem{
  String? title;
  String desc;
  dynamic image;
  bool isImageDelete;
  bool isImageEdit;
  int? id;
  String? update;
  int? storeId;
  bool isFromStore;
  String? create;
  String text;

  RecommendationItem({
    this.title,
    required this.desc,
    required this.text,
    required this.isFromStore,
    this.storeId,
    this.create,
    this.image,
    this.id,
    this.update,
    this.isImageDelete = false,
    this.isImageEdit = false
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) => _$RecommendationItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationItemToJson(this);
}