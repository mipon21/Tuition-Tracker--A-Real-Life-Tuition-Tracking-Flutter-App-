import 'package:hive/hive.dart';

part 'teacher_model.g.dart';
@HiveType(typeId: 0)
class TeacherModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<DateTime> classDates;

  @HiveField(2)
  int paidClassCount;

  @HiveField(3)
  List<int> weeklySchedule;

  @HiveField(4)
  String teachingSubject;

  TeacherModel({
    required this.name,
    required this.classDates,
    required this.paidClassCount,
    required this.weeklySchedule,
    required this.teachingSubject,

  });
}
