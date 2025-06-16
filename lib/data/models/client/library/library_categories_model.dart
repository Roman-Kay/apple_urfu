
import 'package:json_annotation/json_annotation.dart';

part 'library_categories_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryCategoriesResponse{
  LibraryCategoriesResponse({
    required this.code,
    this.message,
    this.categories
});

  int code;
  String? message;
  List<LibraryCategoriesView>? categories;

  factory LibraryCategoriesResponse.fromJson(Map<String, dynamic> json) => _$LibraryCategoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryCategoriesResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryCategoriesView{

  LibraryCategoriesView({
    this.id,
    this.name,
    this.desc
  });

  String? desc;
  int? id;
  String? name;


  factory LibraryCategoriesView.fromJson(Map<String, dynamic> json) => _$LibraryCategoriesViewFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryCategoriesViewToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryCategoriesRequest{

  LibraryCategoriesRequest({
    this.categoryDesc,
    this.categoryId,
    this.categoryName
  });

  @JsonKey(
    name: 'categoryDesc',
  )
  String? categoryDesc;

  @JsonKey(
    name: 'categoryName',
  )
  String? categoryName;

  @JsonKey(
    name: 'categoryId',
  )
  String? categoryId;


  factory LibraryCategoriesRequest.fromJson(Map<String, dynamic> json) => _$LibraryCategoriesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryCategoriesRequestToJson(this);
}