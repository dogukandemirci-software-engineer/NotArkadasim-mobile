import 'meta.dart';

class Result<T> {
  final T? entity;
  final Meta meta;

  Result({
    this.entity,
    required this.meta,
  });

  factory Result.success(T entity, [String? message]) => Result(
    entity: entity,
    meta: Meta.success(message),
  );

  factory Result.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return Result(
      entity: json['entity'] != null ? fromJsonT(json['entity']) : null,
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'entity': entity != null ? toJsonT(entity as T) : null,
    'meta': meta.toJson(),
  };
}

class ResultVoid {
  final Meta meta;

  ResultVoid({required this.meta});

  factory ResultVoid.success([String? message]) => ResultVoid(meta: Meta.success(message));

  factory ResultVoid.fromJson(Map<String, dynamic> json) =>
      ResultVoid(meta: Meta.fromJson(json['meta']));

  Map<String, dynamic> toJson() => {'meta': meta.toJson()};
}
