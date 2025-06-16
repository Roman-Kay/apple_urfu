
import 'package:json_annotation/json_annotation.dart';

part 'diets_request.g.dart';

@JsonSerializable()
class DietsCreate{
  DietsCreate({
    this.productGroups,
    this.nameDiet,
    this.clientId,
    this.additiveStatusId
  });

  int? additiveStatusId;
  int? clientId;
  String? nameDiet;
  List<ProductGroupsCreate>? productGroups;

  factory DietsCreate.fromJson(Map<String, dynamic> json) => _$DietsCreateFromJson(json);
  Map<String, dynamic> toJson() => _$DietsCreateToJson(this);
}


@JsonSerializable()
class ProductGroupsCreate{
  ProductGroupsCreate({
    this.products,
    this.productGroupName
  });

  String? productGroupName;
  List<ProductCreate>? products;

  factory ProductGroupsCreate.fromJson(Map<String, dynamic> json) => _$ProductGroupsCreateFromJson(json);
  Map<String, dynamic> toJson() => _$ProductGroupsCreateToJson(this);

}


@JsonSerializable()
class ProductCreate{
  ProductCreate({
    this.productName,
    this.color,
  });

  String? color;
  String? productName;


  factory ProductCreate.fromJson(Map<String, dynamic> json) => _$ProductCreateFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCreateToJson(this);
}