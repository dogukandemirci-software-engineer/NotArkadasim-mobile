
import 'package:note_arkadasim/models/page.dart';

import 'meta.dart';

class PagingResult<T> {
  final Meta meta;
  final List<T> entities;
  final Page pageInfo;

  PagingResult({
    Meta? meta,
    List<T>? entities,
    Page? pageInfo,
  })  : meta = meta ?? Meta.success(),
        entities = entities ?? [],
        pageInfo = pageInfo ?? Page();

  factory PagingResult.success(List<T> entities, Page pageInfo, [String? message]) =>
      PagingResult(
        meta: Meta.success(message),
        entities: entities,
        pageInfo: pageInfo,
      );

  factory PagingResult.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PagingResult(
      meta: Meta.fromJson(json['meta']),
      entities: json['entities'] != null
          ? (json['entities'] as List).map((e) => fromJsonT(e)).toList()
          : [],
      pageInfo: Page.fromJson(json['pageInfo']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'meta': meta.toJson(),
    'entities': entities.map((e) => toJsonT(e)).toList(),
    'pageInfo': pageInfo.toJson(),
  };
}
