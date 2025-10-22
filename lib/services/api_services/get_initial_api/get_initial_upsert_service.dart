

import 'package:note_arkadasim/constants/fakes/departments.dart';
import 'package:note_arkadasim/models/College.dart';
import 'package:note_arkadasim/models/Department.dart';

import '../../../constants/fakes/colleges.dart';

class GetInitialUpsertService {
  static late final GetInitialUpsertService _instance = GetInitialUpsertService._internal();

  GetInitialUpsertService._internal();

  static GetInitialUpsertService get instance => _instance;

  Future<List<College>> getColleges() async {
    return await _fakeGetColleges();
  }

  Future<List<Department>> getDepartments() async {
    return await _fakeGetDepartments();
  }

  Future<List<College>> _fakeGetColleges() async {
    await Future.delayed(const Duration(milliseconds: 1200)); // Simülasyon
    return colleges;
  }

  Future<List<Department>> _fakeGetDepartments() async {
    await Future.delayed(const Duration(milliseconds: 1200)); // Simülasyon
    return departments;
  }
}