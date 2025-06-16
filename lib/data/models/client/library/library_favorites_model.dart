

import 'package:garnetbook/data/models/client/library/library_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'library_favorites_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryFavoritesRequest{

  LibraryFavoritesRequest({
    this.id,
    this.libId
  });

  @JsonKey(
    name: 'libId',
  )
  int? libId;

  int? id;


  factory LibraryFavoritesRequest.fromJson(Map<String, dynamic> json) => _$LibraryFavoritesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryFavoritesRequestToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryFavoritesResponse{

  LibraryFavoritesResponse({
    required this.code,
    this.message,
    this.libraryFavorite
  });

  int code;

  @JsonKey(
    name: 'libraryFavorite',
  )
  LibraryFavoritesView? libraryFavorite;

  String? message;

  factory LibraryFavoritesResponse.fromJson(Map<String, dynamic> json) => _$LibraryFavoritesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryFavoritesResponseToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryFavoritesView{

  LibraryFavoritesView({
    this.userId,
    this.firstName,
    this.lastName,
    this.libs
});

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;

  @JsonKey(
    name: 'userId',
  )
  int? userId;

  List<LibraryView>? libs;


  factory LibraryFavoritesView.fromJson(Map<String, dynamic> json) => _$LibraryFavoritesViewFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryFavoritesViewToJson(this);
}