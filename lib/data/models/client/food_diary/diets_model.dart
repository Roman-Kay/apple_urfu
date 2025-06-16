
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diets_model.g.dart';

@JsonSerializable()
class Diets{
  Diets({
    this.clientId,
    this.createDate,
    this.expertId,
    this.firstNameClient,
    this.firstNameExpert,
    this.id,
    this.lastNameClient,
    this.lastNameExpert,
    this.nameDiet,
    this.positionExpert,
    this.productGroups,
    this.status,
  });

  int? clientId;
  String? createDate;
  int? expertId;
  String? firstNameClient;
  String? firstNameExpert;
  int? id;
  String? lastNameClient;
  String? lastNameExpert;
  String? nameDiet;
  String? positionExpert;
  List<ProductGroups>? productGroups;
  AdditiveStatusesView? status;


  factory Diets.fromJson(Map<String, dynamic> json) => _$DietsFromJson(json);
  Map<String, dynamic> toJson() => _$DietsToJson(this);
}


@JsonSerializable()
class ProductGroups{
  ProductGroups({
    this.id,
    this.productGroupName,
    this.products
});

  int? id;
  String? productGroupName;
  List<Product>? products;

  factory ProductGroups.fromJson(Map<String, dynamic> json) => _$ProductGroupsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductGroupsToJson(this);
}


@JsonSerializable()
class Product{
  Product({
    this.id,
    this.color,
    this.productName
});

  String? color;
  int? id;
  String? productName;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}


