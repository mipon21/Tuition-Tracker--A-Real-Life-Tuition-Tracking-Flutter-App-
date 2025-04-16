import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/controllers/general_controller.dart';
import 'package:student_management/controllers/teacher_controller.dart';
import 'package:student_management/models/teacher_model.dart';
import 'package:student_management/utils/constants/colors.dart';
import 'package:student_management/utils/constants/sizes.dart';
import '../controllers/student_controller.dart';
import '../models/student_model.dart';

class AddEditStudentScreen extends StatefulWidget {
  const AddEditStudentScreen({super.key});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final nameController = TextEditingController();
  final paidClassCountController = TextEditingController();
  final paidAmountController = TextEditingController();
  final subjectController = TextEditingController();
  List<int> selectedDays = [];
  final generalController = Get.find<GeneralController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            generalController.selectedIndex.value == 0
                ? Text('Add Student')
                : Text('Add Teacher'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: MColors.primary),
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  MColors.primary,
                  MColors.primary,
                ], // Minty green to sky blue
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
                onClickdo();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration().copyWith(
                  hintText:
                      generalController.selectedIndex.value == 0
                          ? 'Enter Student Name'
                          : 'Enter Teacher Name',
                  border: OutlineInputBorder(),
                  labelText:
                      generalController.selectedIndex.value == 0
                          ? 'Name of the Student'
                          : 'Name of the Teacher',
                  focusedBorder: const OutlineInputBorder().copyWith(
                    borderRadius: BorderRadius.circular(
                      MSizes.inputFieldRadius,
                    ),
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: MColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: paidClassCountController,
                decoration: const InputDecoration().copyWith(
                  hintText: 'Total class in a month',
                  border: const OutlineInputBorder(),
                  labelText: 'Paid Class Count',
                  focusedBorder: const OutlineInputBorder().copyWith(
                    borderRadius: BorderRadius.circular(
                      MSizes.inputFieldRadius,
                    ),
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: MColors.primary,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10),
              generalController.selectedIndex.value == 0
                  ? TextField(
                    controller: paidAmountController,
                    decoration: const InputDecoration().copyWith(
                      hintText: 'Total Pay Amount',
                      border: const OutlineInputBorder(),
                      labelText: 'Total Pay Amount',
                      focusedBorder: const OutlineInputBorder().copyWith(
                        borderRadius: BorderRadius.circular(
                          MSizes.inputFieldRadius,
                        ),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: MColors.primary,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  )
                  : TextField(
                    controller: subjectController,
                    decoration: const InputDecoration().copyWith(
                      hintText: 'eg: Math, English',
                      border: const OutlineInputBorder(),
                      labelText: 'Teaching Subjects',
                      focusedBorder: const OutlineInputBorder().copyWith(
                        borderRadius: BorderRadius.circular(
                          MSizes.inputFieldRadius,
                        ),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: MColors.primary,
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 50),
              const Text(
                'Weekly Schedule:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Wrap(
                spacing: 15,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(7, (i) {
                  final weekday = i + 1;
                  final name =
                      [
                        'Saturday',
                        'Sunday',
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                      ][i];
                  final isSelected = selectedDays.contains(weekday);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: 150,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedDays.remove(weekday);
                          } else {
                            selectedDays.add(weekday);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient:
                              isSelected
                                  ? const LinearGradient(
                                    colors: [
                                      Color(0xFF0ED2F7),
                                      Color(0xFF0ED2F7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : const LinearGradient(
                                    colors: [
                                      Color(0xFFE0E0E0),
                                      Color(0xFFF5F5F5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onClickdo();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onClickdo() {
    {
      if (generalController.selectedIndex.value == 0) {
        if (nameController.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter a name',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.red,
          );
          return;
        }
        if (paidClassCountController.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter paid class count',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.white,
          );
          return;
        }
        if (selectedDays.isEmpty) {
          Get.snackbar(
            'Error',
            'Please select at least one day',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.white,
          );
          return;
        }
        if (paidAmountController.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter total payment amount',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.white,
          );
          return;
        }
        final student = StudentModel(
          name: nameController.text.trim(),
          classDates: [],
          paidClassCount: int.tryParse(paidClassCountController.text) ?? 0,
          weeklySchedule: selectedDays,
          totalPayment: double.tryParse(paidAmountController.text) ?? 0,
        );
        Get.find<StudentController>().addStudent(student);
        Get.back();
      } else {
        if (nameController.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter a name',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.red,
          );
          return;
        }
        if (paidClassCountController.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter paid class count',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.white,
          );
          return;
        }
        if (selectedDays.isEmpty) {
          Get.snackbar(
            'Error',
            'Please select at least one day',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.white,
          );
          return;
        }
        if (subjectController.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter subject names seperated by commas',
            backgroundColor: const Color.fromARGB(205, 240, 225, 225),
            colorText: Colors.white,
          );
          return;
        }
        final teacher = TeacherModel(
          name: nameController.text.trim(),
          classDates: [],
          paidClassCount: int.tryParse(paidClassCountController.text) ?? 0,
          weeklySchedule: selectedDays,
          teachingSubject: subjectController.text.trim(),
        );

        

        Get.find<TeacherController>().addTeacher(teacher);
        Get.back();
      }
    }
  }
}
