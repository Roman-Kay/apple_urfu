
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_create_model.g.dart';

@JsonSerializable()
class ClientFoodCreateRequest{
  ClientFoodCreateRequest({
    this.drinks,
    this.waters,
    this.foods,
});

  List<Drink>? drinks;
  List<Water>? waters;
  List<Food>? foods;


  factory ClientFoodCreateRequest.fromJson(Map<String, dynamic> json) => _$ClientFoodCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientFoodCreateRequestToJson(this);
}


@JsonSerializable()
class Drink{
  Drink({
    this.id,
    this.portion,
    this.foodName,
    this.calories,
    this.foodPeriod,
    this.comment,
    this.feel,
    this.photo,
    this.foodTime
});

  int? calories;
  String? foodName;
  int? id;
  int? portion;
  int? foodPeriod;
  String? feel;
  String? foodTime;
  String? comment;
  ImageView? photo;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
  Map<String, dynamic> toJson() => _$DrinkToJson(this);
}


@JsonSerializable()
class Food{
  Food({
    this.calories,
    this.foodName,
    this.portion,
    this.id,
    this.comment,
    this.foodColors,
    this.foodTime,
    this.xe,
    this.photo,
    this.foodPeriod,
    this.feel
});

  int? calories;
  String? comment;
  String? feel;
  List<int>? foodColors;
  String? foodName;
  String? foodTime;
  int? foodPeriod;
  int? id;
  ImageView? photo;
  int? portion;
  int? xe;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}


@JsonSerializable()
class Water{
  Water({
    this.id,
    this.portion,
    this.foodPeriod,
    this.calories,
    this.foodName,
    this.foodTime
});

  int? calories;
  int? id;
  int? portion;
  int? foodPeriod;
  String? foodName;
  String? foodTime;

  factory Water.fromJson(Map<String, dynamic> json) => _$WaterFromJson(json);
  Map<String, dynamic> toJson() => _$WaterToJson(this);
}