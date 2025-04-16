import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/teacher_model.dart';

class TeacherController extends GetxController {
  final teacherBox = Hive.box<TeacherModel>('teachers');
  RxList<TeacherModel> teachers = <TeacherModel>[].obs;

  final searchQuery = ''.obs;

  List<TeacherModel> get filteredTeachers {
    if (searchQuery.value.isEmpty) return teachers;
    return teachers
        .where((t) =>
            t.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            t.teachingSubject.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onInit() {
    super.onInit();
    teachers.value = teacherBox.values.toList();
  }

  void addTeacher(TeacherModel teacher) {
    teacherBox.add(teacher);
    teachers.value = teacherBox.values.toList();
  }

  void updateTeacher(int index, TeacherModel updated) {
    teacherBox.putAt(index, updated);
    teachers.value = teacherBox.values.toList();
  }

  void deleteTeacher(int index) {
    teacherBox.deleteAt(index);
    teachers.value = teacherBox.values.toList();
  }

  void markClass(int teacherIndex, DateTime date) {
    final teacher = teachers[teacherIndex];
    if (!teacher.classDates.contains(date)) {
      teacher.classDates.add(date);
      teacher.save();
      teachers[teacherIndex] = teacher;
    }
  }

  void removeClassDate(int teacherIndex, DateTime date) {
    final teacher = teachers[teacherIndex];
    teacher.classDates.remove(date);
    teacher.save();
    teachers[teacherIndex] = teacher;
  }
}
