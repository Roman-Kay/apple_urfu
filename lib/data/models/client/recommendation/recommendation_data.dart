import 'package:json_annotation/json_annotation.dart';

part 'recommendation_data.g.dart';

@JsonSerializable()
class ArticleItem {
  ArticleItem({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
  });

  final int? id;
  final String? title;
  final Image? image;
  final String? content;

  factory ArticleItem.fromJson(Map<String, dynamic> json) => _$ArticleItemFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleItemToJson(this);

}

@JsonSerializable()
class RecommendationData {
  RecommendationData({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    required this.pointTitle,
    required this.pointsData,
  });

  final int? id;
  final String? title;
  final Image? image;
  final String? content;

  @JsonKey(name: 'point_title')
  final String? pointTitle;

  @JsonKey(name: 'points_data')
  final List<PointsDatum>? pointsData;

  factory RecommendationData.fromJson(Map<String, dynamic> json) => _$RecommendationDataFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationDataToJson(this);

}

@JsonSerializable()
class Image {
  Image({
    required this.mimeType,
    required this.content,
  });

  final String? mimeType;
  final String? content;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);

}

@JsonSerializable()
class PointsDatum {
  PointsDatum({
    required this.title,
    required this.icon,
    required this.content,
    required this.comment,
  });

  final String? title;
  final Image? icon;
  final String? content;
  final String? comment;

  factory PointsDatum.fromJson(Map<String, dynamic> json) => _$PointsDatumFromJson(json);

  Map<String, dynamic> toJson() => _$PointsDatumToJson(this);

}
