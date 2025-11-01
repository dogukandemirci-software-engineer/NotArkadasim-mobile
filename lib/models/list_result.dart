
import 'meta.dart';

class ListResult<T> {
  final Meta meta;
  final List<T> entities;

  ListResult({Meta? meta, List<T>? entities})
      : meta = meta ?? Meta.success(),
        entities = entities ?? [];

  factory ListResult.success(List<T> entities, [String? message]) => ListResult(
    meta: Meta.success(message),
    entities: entities,
  );

  factory ListResult.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ListResult(
      meta: Meta.fromJson(json['meta']),
      entities: json['entities'] != null
          ? (json['entities'] as List).map((e) => fromJsonT(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'meta': meta.toJson(),
    'entities': entities.map((e) => toJsonT(e)).toList(),
  };
}
