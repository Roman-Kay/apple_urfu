

import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_diary_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientFoodResponse{
  ClientFoodResponse({
    required this.code,
    this.message,
    this.foods
});

  int code;
  String? message;
  List<ClientFoodView>? foods;

  factory ClientFoodResponse.fromJson(Map<String, dynamic> json) => _$ClientFoodResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientFoodResponseToJson(this);

}


@JsonSerializable()
class ClientFoodView{
  ClientFoodView({
    this.clientId,
    this.clientFirstName,
    this.clientLastName,
    this.dayCalories,
    this.imt,
    this.normCalories,
    this.drinks,
    this.foods,
    this.waters,
    this.dateFood
});


  String? clientFirstName;
  int? clientId;
  String? clientLastName;
  String? dateFood;
  int? dayCalories;
  List<DrinkView>? drinks;
  List<FoodView>? foods;
  num? imt;
  int? normCalories;
  List<WaterView>? waters;


  factory ClientFoodView.fromJson(Map<String, dynamic> json) => _$ClientFoodViewFromJson(json);
  Map<String, dynamic> toJson() => _$ClientFoodViewToJson(this);
}

@JsonSerializable()
class DrinkView{
  DrinkView({
    this.id,
    this.portion,
    this.foodName,
    this.calories,
    this.update,
    this.create,
    this.foodPeriod,
    this.comment,
    this.drinkPhoto,
    this.foodTime,
    this.expertComment
});

  int? calories;
  String? create;
  String? foodName;
  String? expertComment;
  int? foodPeriod;
  String? foodTime;
  int? id;
  int? portion;
  String? update;
  String? comment;
  FileView? drinkPhoto;

  factory DrinkView.fromJson(Map<String, dynamic> json) => _$DrinkViewFromJson(json);
  Map<String, dynamic> toJson() => _$DrinkViewToJson(this);
}

@JsonSerializable()
class FoodView{
  FoodView({
    this.create,
    this.update,
    this.calories,
    this.foodName,
    this.portion,
    this.id,
    this.xe,
    this.foodTime,
    this.foodColors,
    this.foodPhoto,
    this.colors,
    this.foodPeriod,
    this.periodCalories,
    this.comment,
    this.feel,
    this.expertComment
});

  int? calories;
  List<ColorView>? colors;
  String? create;
  String? foodColors;
  String? foodName;
  String? expertComment;
  int? foodPeriod;
  FileView? foodPhoto;
  String? foodTime;
  int? id;
  int? periodCalories;
  int? portion;
  String? update;
  int? xe;
  String? comment;
  String? feel;

  factory FoodView.fromJson(Map<String, dynamic> json) => _$FoodViewFromJson(json);
  Map<String, dynamic> toJson() => _$FoodViewToJson(this);
}


@JsonSerializable()
class WaterView{
  WaterView({
    this.id,
    this.portion,
    this.foodName,
    this.update,
    this.create,
    this.foodPeriod,
    this.calories
});

  int? calories;
  String? create;
  String? foodName;
  int? foodPeriod;
  int? id;
  int? portion;
  String? update;

  factory WaterView.fromJson(Map<String, dynamic> json) => _$WaterViewFromJson(json);
  Map<String, dynamic> toJson() => _$WaterViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ClientFoodRequest{
  ClientFoodRequest({
    this.dateBy,
    this.dateFrom,
    this.clientId
});

  @JsonKey(
    name: 'clientId',
  )
  int? clientId;

  @JsonKey(
    name: 'dateFrom',
  )
  String? dateFrom;

  @JsonKey(
    name: 'dateBy',
  )
  String? dateBy;

  factory ClientFoodRequest.fromJson(Map<String, dynamic> json) => _$ClientFoodRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClientFoodRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class ColorView{

  ColorView({
    this.id,
    this.code,
    this.name
});

  String? code;
  int? id;
  String? name;


  factory ColorView.fromJson(Map<String, dynamic> json) => _$ColorViewFromJson(json);
  Map<String, dynamic> toJson() => _$ColorViewToJson(this);
}



@JsonSerializable()
class RainbowPhytonutrientsRequest{
  RainbowPhytonutrientsRequest({
    required this.foodColors,
    this.id
});

  List<int> foodColors;
  int? id;

  factory RainbowPhytonutrientsRequest.fromJson(Map<String, dynamic> json) => _$RainbowPhytonutrientsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RainbowPhytonutrientsRequestToJson(this);
}


@JsonSerializable()
class FoodEditCommentRequest{
  FoodEditCommentRequest({
    this.id,
    this.clientId,
    this.expertComment
});

  int? id;
  int? clientId;
  String? expertComment;

  factory FoodEditCommentRequest.fromJson(Map<String, dynamic> json) => _$FoodEditCommentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FoodEditCommentRequestToJson(this);
}