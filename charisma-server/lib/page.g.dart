// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
    sys: json['sys'] == null
        ? null
        : SystemFields.fromJson(json['sys'] as Map<String, dynamic>),
    fields: json['fields'] == null
        ? null
        : PageFields.fromJson(json['fields'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'sys': instance.sys,
      'fields': instance.fields,
    };

PageFields _$PageFieldsFromJson(Map<String, dynamic> json) {
  return PageFields(
    title: json['title'] as String,
    pageid: json['pageid'] as String,
  );
}

Map<String, dynamic> _$PageFieldsToJson(PageFields instance) =>
    <String, dynamic>{
      'title': instance.title,
      'pageid': instance.pageid,
    };
