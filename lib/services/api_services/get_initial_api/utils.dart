
import '../../../models/College.dart';
import '../../../models/Department.dart';

class GetInitialUpsertServiceUtils {

  static List<String> extractColleges(List<College> colleges) {
    return colleges.map((college) {
      return college.name;
    }).toList();
  }

  static List<String> extractDepartments(List<Department> departments) {
    return departments.map((department) {
      return department.name;
    }).toList();
  }

}