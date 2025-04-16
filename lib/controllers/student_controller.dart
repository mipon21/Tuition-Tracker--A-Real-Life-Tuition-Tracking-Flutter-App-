import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/student_model.dart';

class StudentController extends GetxController {
  final studentBox = Hive.box<StudentModel>('students');
  RxList<StudentModel> students = <StudentModel>[].obs;

    final searchQuery = ''.obs;

  List<StudentModel> get filteredStudents {
    if (searchQuery.value.isEmpty) return students;
    return students
        .where((s) => s.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onInit() {
    super.onInit();
    students.value = studentBox.values.toList();
  }

  void addStudent(StudentModel student) {
    studentBox.add(student);
    students.value = studentBox.values.toList();
  }

  void updateStudent(int index, StudentModel updated) {
    studentBox.putAt(index, updated);
    students.value = studentBox.values.toList();
  }

  void deleteStudent(int index) {
    studentBox.deleteAt(index);
    students.value = studentBox.values.toList();
  }

  void markClass(int studentIndex, DateTime date) {
    final student = students[studentIndex];
    if (!student.classDates.contains(date)) {
      student.classDates.add(date);
      student.save();
      students[studentIndex] = student;
    }
  }

  void removeClassDate(int studentIndex, DateTime date) {
    final student = students[studentIndex];
    student.classDates.remove(date);
    student.save();
    students[studentIndex] = student;
  }
}
