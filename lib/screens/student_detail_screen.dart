// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/controllers/general_controller.dart';
import 'package:student_management/controllers/teacher_controller.dart';
import 'package:student_management/utils/constants/colors.dart';
import 'package:student_management/widgets/student_card.dart';
import 'package:student_management/widgets/student_card_details.dart';
import 'package:student_management/widgets/teacher_card_detail.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/student_controller.dart';

class StudentDetailScreen extends StatefulWidget {
  final int index;
  const StudentDetailScreen({super.key, required this.index});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  DateTime focusedDay = DateTime.now();
  StudentController controller = Get.find();
  TeacherController teacherController = Get.find();
  GeneralController generalController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isStudent = generalController.selectedIndex.value == 0;

    final student = isStudent ? controller.students[widget.index] : null;
    final teacher =
        !isStudent ? teacherController.teachers[widget.index] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isStudent ? "Student Details" : "Teacher Details"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: MColors.primary),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0ED2F7), Color(0xFF0ED2F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.done_all),
              color: Colors.white,
              iconSize: 24,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isStudent && student != null)
              StudentCardDetails(student: student)
            else if (!isStudent && teacher != null)
              TeacherCardDetails(teacher: teacher),
            const SizedBox(height: 10),

            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: focusedDay,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},

              selectedDayPredicate: (day) {
                if (isStudent && student != null) {
                  return student.classDates.any((d) => isSameDay(d, day));
                } else if (!isStudent && teacher != null) {
                  return teacher.classDates.any((d) => isSameDay(d, day));
                }
                return false;
              },

              onDaySelected: (selectedDay, focused) {
                setState(() => focusedDay = focused);

                final exists =
                    isStudent && student != null
                        ? student.classDates.any(
                          (d) => isSameDay(d, selectedDay),
                        )
                        : teacher?.classDates.any(
                              (d) => isSameDay(d, selectedDay),
                            ) ??
                            false;

                if (exists) {
                  Get.defaultDialog(
                    title: "Remove Class Date?",
                    middleText:
                        "Do you want to remove ${selectedDay.toLocal().toString().split(' ')[0]} from this ${isStudent ? "student" : "teacher"}'s class history?",
                    textConfirm: "Yes, Remove",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      setState(() {
                        isStudent
                            ? controller.removeClassDate(
                              widget.index,
                              selectedDay,
                            )
                            : teacherController.removeClassDate(
                              widget.index,
                              selectedDay,
                            );
                      });
                      Get.back();
                    },
                    onCancel: () {},
                  );
                } else {
                  isStudent
                      ? controller.markClass(widget.index, selectedDay)
                      : teacherController.markClass(widget.index, selectedDay);
                }
              },

              // 💡 This is key: no calendarBuilders to override rendering
              // 💡 Style for visible, dimmed outside days
              calendarStyle: const CalendarStyle(
                outsideTextStyle: TextStyle(color: Colors.grey),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: MColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Class Dates:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (isStudent && student != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: MColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${student.weeklySchedule.map((e) => ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'][e - 1]).join(', ')}',
                      style: TextStyle(
                        color: MColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else if (!isStudent && teacher != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: MColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${teacher.weeklySchedule.map((e) => ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'][e - 1]).join(', ')}',
                      style: TextStyle(
                        color: MColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
