// Doğrudan Department nesnelerinden oluşan liste (List<Department> tipinde)
import '../../models/Department.dart';

final List<Department> departments = [
  // BÜTÜN INSTANCE'LAR categoryId ALIYOR
  Department(id: 'D01', categoryId: 'CAT_COMP', name: 'Bilgisayar Mühendisliği'),
  Department(id: 'D02', categoryId: 'CAT_ELEC', name: 'Elektrik-Elektronik Mühendisliği'),
  Department(id: 'D03', categoryId: 'CAT_MECH', name: 'Makine Mühendisliği'),
  Department(id: 'D04', categoryId: 'CAT_IND', name: 'Endüstri Mühendisliği'),
  Department(id: 'D05', categoryId: 'CAT_CONS', name: 'İnşaat Mühendisliği'),
  Department(id: 'D06', categoryId: 'CAT_COMP', name: 'Yazılım Mühendisliği'),
  Department(id: 'D03', categoryId: 'CAT_MECH', name: 'Makine Mühendisliği'),
];