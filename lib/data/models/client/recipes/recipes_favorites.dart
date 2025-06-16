

import 'package:garnetbook/data/models/client/recipes/recipes_response.dart';
import 'package:garnetbook/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipes_favorites.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeFavoritesResponse{
  RecipeFavoritesResponse({
    required this.code,
    this.message,
    this.recipeFavorite
});
  int code;
  String? message;

  @JsonKey(
    name: 'recipeFavorite',
  )
  List<RecipeFavoritesView>? recipeFavorite;

  factory RecipeFavoritesResponse.fromJson(Map<String, dynamic> json) => _$RecipeFavoritesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeFavoritesResponseToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class RecipeFavoritesView{
  RecipeFavoritesView({
    this.create,
    this.update,
    this.recipes,
    this.user,
    this.createFavorites,
    this.recipeFavoritesId
});

  String? create;

  @JsonKey(
    name: 'createFavorites',
  )
  String? createFavorites;

  @JsonKey(
    name: 'recipeFavoritesId',
  )
  int? recipeFavoritesId;
  String? update;
  RecipesView? recipes;
  UserView? user;

  factory RecipeFavoritesView.fromJson(Map<String, dynamic> json) => _$RecipeFavoritesViewFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeFavoritesViewToJson(this);
}


@JsonSerializable()
class RecipeFavoritesRequest{

  RecipeFavoritesRequest({
    this.recipeId,
    this.userToId
});


  int? recipeId;
  int? userToId;

  factory RecipeFavoritesRequest.fromJson(Map<String, dynamic> json) => _$RecipeFavoritesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeFavoritesRequestToJson(this);
}