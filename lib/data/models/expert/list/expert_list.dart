
import 'package:garnetbook/data/models/expert/profile/profile_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expert_list.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertShortCardResponse{
  ExpertShortCardResponse({
    this.code,
    this.message,
    this.expertCardList,
    this.page,
    this.totalElement,
    this.totalPage
});

  int? code;
  String? message;
  int? page;

  @JsonKey(
    name: 'totalElement',
  )
  int? totalElement;

  @JsonKey(
    name: 'totalPage',
  )
  int? totalPage;

  @JsonKey(
    name: 'expertCardList',
  )
  List<ExpertShortCardView>? expertCardList;

  factory ExpertShortCardResponse.fromJson(Map<String, dynamic> json) => _$ExpertShortCardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertShortCardResponseToJson(this);

}


@JsonSerializable(fieldRename: FieldRename.snake)
class ExpertShortCardView{
  ExpertShortCardView({
    this.lastName,
    this.firstName,
    this.expertId,
    this.position,
    this.categoryId,
    this.isClientExpert,
    this.rating,
    this.avatarBase64
});

  @JsonKey(
    name: 'avatarBase64',
  )
  FileView? avatarBase64;

  @JsonKey(
    name: 'expertId',
  )
  int? expertId;

  @JsonKey(
    name: 'firstName',
  )
  String? firstName;

  @JsonKey(
    name: 'categoryId',
  )
  ReferenceExpertCategoriesView? categoryId;

  @JsonKey(
    name: 'isClientExpert',
  )
  bool? isClientExpert;

  @JsonKey(
    name: 'lastName',
  )
  String? lastName;
  String? position;
  int? rating;

  factory ExpertShortCardView.fromJson(Map<String, dynamic> json) => _$ExpertShortCardViewFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertShortCardViewToJson(this);
}













