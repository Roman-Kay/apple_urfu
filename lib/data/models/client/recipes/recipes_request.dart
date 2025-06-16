
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipes_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipesRequest{
  RecipesRequest({
    this.recipeText,
    this.recipeName,
    this.recipeId,
    this.recipeDesc,
    this.tags,
    this.img
});

  ImageView? img;

  @JsonKey(
    name: 'recipeDesc',
  )
  String? recipeDesc;

  @JsonKey(
    name: 'recipeId',
  )
  int? recipeId;

  @JsonKey(
    name: 'recipeName',
  )
  String? recipeName;

  @JsonKey(
    name: 'recipeText',
  )
  String? recipeText;
  String? tags;

  factory RecipesRequest.fromJson(Map<String, dynamic> json) => _$RecipesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RecipesRequestToJson(this);
}