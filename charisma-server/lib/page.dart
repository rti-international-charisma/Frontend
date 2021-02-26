import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:contentful/contentful.dart';

part 'page.g.dart';


@JsonSerializable()
class Page extends Entry<PageFields> {
  Page({
    SystemFields sys,
    PageFields fields,
  }) : super(sys: sys, fields: fields);

  static Page fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}

@JsonSerializable()
class PageFields extends Equatable {
  const PageFields({
    this.title,
    this.pageid,
  });

  final String title;
  final String pageid;

  static PageFields fromJson(Map<String, dynamic> json) =>
      _$PageFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$PageFieldsToJson(this);

  @override
  List<Object> get props => [title, pageid];


}