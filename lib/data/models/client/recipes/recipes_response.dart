
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipes_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipesResponse{
  RecipesResponse({
    required this.code,
    this.message,
    this.recipes
});
  int code;
  String? message;
  List<RecipesView>? recipes;

  factory RecipesResponse.fromJson(Map<String, dynamic> json) => _$RecipesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecipesResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class RecipesView{
  RecipesView({
    this.update,
    this.create,
    this.tags,
    this.file,
    this.favorites,
    this.recipeDesc,
    this.recipeId,
    this.recipeName,
    this.recipeFavoritesId,
    this.recipeText
});

  String? create;
  bool? favorites;
  FileView? file;

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
  String? update;
  @JsonKey(
    name: 'recipeFavoritesId',
  )
  int? recipeFavoritesId;

  factory RecipesView.fromJson(Map<String, dynamic> json) => _$RecipesViewFromJson(json);
  Map<String, dynamic> toJson() => _$RecipesViewToJson(this);
}