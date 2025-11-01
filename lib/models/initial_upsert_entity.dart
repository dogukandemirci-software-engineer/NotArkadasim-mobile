import 'College.dart';
import 'Department.dart';
import 'dart:convert';

class InitialUpsertEntity {
  final List<College> collages;
  final List<Department> departments;

  InitialUpsertEntity({required this.collages, required this.departments});

  factory InitialUpsertEntity.fromJson(Map<String, dynamic> json) =>
      InitialUpsertEntity(
        collages: json['collages'] != null
            ? (json['collages'] as List)
            .map((e) => College.fromJson(e))
            .toList()
            : [],
        departments: json['departments'] != null
            ? (json['departments'] as List)
            .map((e) => Department.fromJson(e))
            .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
    'collages': collages.map((e) => e.toJson()).toList(),
    'departments': departments.map((e) => e.toJson()).toList(),
  };
}