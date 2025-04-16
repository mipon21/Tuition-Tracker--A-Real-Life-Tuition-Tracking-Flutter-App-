import 'package:hive/hive.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<DateTime> classDates;

  @HiveField(2)
  int paidClassCount;

  @HiveField(3)
  List<int> weeklySchedule;

  @HiveField(4)
  double? totalPayment;

  StudentModel({
    required this.name,
    required this.classDates,
    required this.paidClassCount,
    required this.weeklySchedule,
    this.totalPayment = 0.0,

  });
}
