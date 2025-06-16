
import 'package:garnetbook/data/models/client/library/library_categories_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'library_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryResponse{
  LibraryResponse({
    required this.code,
    this.message,
    this.library
  });

  int code;
  List<LibraryView>? library;
  String? message;

  factory LibraryResponse.fromJson(Map<String, dynamic> json) => _$LibraryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryResponseToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class LibraryView{

  LibraryView({
    this.name,
    this.id,
    this.text,
    this.update,
    this.create,
    this.tags,
    this.category,
    this.favorites,
    this.file
  });

  LibraryCategoriesView? category;
  String? create;
  int? favorites;
  int? id;
  String? name;
  String? tags;
  String? text;
  String? update;

  FileView? file;

  factory LibraryView.fromJson(Map<String, dynamic> json) => _$LibraryViewFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryViewToJson(this);
}