
import 'package:json_annotation/json_annotation.dart';

part 'file_view.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class FileView{
  FileView({
    this.fileBase64,
    this.fileExtension
});

  @JsonKey(
    name: 'fileBase64',
  )
  String? fileBase64;

  @JsonKey(
    name: 'fileExtension',
  )
  String? fileExtension;

  factory FileView.fromJson(Map<String, dynamic> json) => _$FileViewFromJson(json);
  Map<String, dynamic> toJson() => _$FileViewToJson(this);
}