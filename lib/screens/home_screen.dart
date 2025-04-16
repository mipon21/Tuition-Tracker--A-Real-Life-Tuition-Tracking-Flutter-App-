// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:student_management/controllers/general_controller.dart';
import 'package:student_management/controllers/teacher_controller.dart';
import 'package:student_management/screens/add_student_screen.dart';
import 'package:student_management/utils/constants/colors.dart';
import 'package:student_management/utils/constants/sizes.dart';
import 'package:student_management/utils/helper_functions.dart';
import 'package:student_management/widgets/student_card.dart'; // 👈 Import StudentCard
import 'package:student_management/widgets/teacher_card.dart';
import '../controllers/student_controller.dart';
import 'student_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentController controller = Get.put(StudentController());
  final TeacherController teacherController = Get.put(TeacherController());
  final GeneralController generalController = Get.put(GeneralController());
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = MHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title:
            isSearching
                ? Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  width: double.infinity,
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search names...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged:
                        generalController.selectedIndex.value == 0
                            ? controller.updateSearchQuery
                            : teacherController.updateSearchQuery,
                  ),
                )
                : const Text(
                  'tuition Tracker',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu_outlined, color: MColors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                  generalController.selectedIndex.value == 0
                      ? controller.updateSearchQuery('')
                      : teacherController.updateSearchQuery('');
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0ED2F7), Color(0xFF0ED2F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          //   child: TextField(
          //     controller: _searchController,

          //     decoration: InputDecoration().copyWith(
          //       hintText: 'Search students...',
          //       prefixIcon: const Icon(Icons.search),
          //       contentPadding: const EdgeInsets.symmetric(
          //         vertical: 0,
          //         horizontal: 20,
          //       ),
          //       border: const OutlineInputBorder().copyWith(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: const BorderSide(width: 1, color: MColors.grey),
          //       ),
          //       enabledBorder: const OutlineInputBorder().copyWith(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: const BorderSide(width: 1, color: MColors.grey),
          //       ),
          //       focusedBorder: const OutlineInputBorder().copyWith(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: const BorderSide(
          //           width: 1,
          //           color: MColors.primary,
          //         ),
          //       ),
          //     ),
          //     onChanged: controller.updateSearchQuery,
          //   ),
          // ),

          // 📋 Filtered Student List
          Expanded(
            child: Obx(() {
              final students = controller.filteredStudents;
              final teachers = teacherController.filteredTeachers;
              final selectedIndex = generalController.selectedIndex.value;

              if (selectedIndex == 0) {
                if (students.isEmpty) {
                  return Center(
                    child: Text(
                      'No Students Found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
              } else {
                if (teachers.isEmpty) {
                  return Center(
                    child: Text(
                      'No Teachers Found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount:
                    generalController.selectedIndex.value == 0
                        ? students.length
                        : teachers.length,
                itemBuilder: (context, index) {
                  if (generalController.selectedIndex.value == 0) {
                    final student = students[index];
                    return GestureDetector(
                      onTap:
                          () => Get.to(
                            () => StudentDetailScreen(
                              index: controller.students.indexOf(student),
                            ),
                          ),
                      onLongPress:
                          () => Get.defaultDialog(
                            title: "Remove Student?",
                            middleText:
                                "Do you want to remove ${student.name} from the list?",
                            textConfirm: "Yes, Remove",
                            textCancel: "Cancel",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              controller.deleteStudent(
                                controller.students.indexOf(student),
                              );
                              Get.back();
                            },
                          ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          StudentCard(student: student),
                        ],
                      ),
                    );
                  } else {
                    final teacher = teachers[index];
                    return GestureDetector(
                      onTap:
                          () => Get.to(
                            () => StudentDetailScreen(
                              index: teacherController.teachers.indexOf(
                                teacher,
                              ),
                            ),
                          ),
                      onLongPress:
                          () => Get.defaultDialog(
                            title: "Remove Teacher?",
                            middleText:
                                "Do you want to remove ${teacher.name} from the list?",
                            textConfirm: "Yes, Remove",
                            textCancel: "Cancel",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              teacherController.deleteTeacher(
                                teacherController.teachers.indexOf(teacher),
                              );
                              Get.back();
                            },
                          ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          TeacherCard(teacher: teacher),
                        ],
                      ),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: isDark ? MColors.dark : MColors.white,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: DrawerHeader(
                decoration: BoxDecoration(color: MColors.primary),
                child: SvgPicture.asset('assets/logo_drawer.svg', height: 100),
              ),
            ),
            Text(
              'Tuition Tracker',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Developed by:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Md. Muahidur Rahman Mipon.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),

            ListTile(
              title:
                  isDark
                      ? const Text('Switch to Light Theme')
                      : const Text('Switch to Dark Theme'),
              trailing: Switch(
                activeColor: MColors.primary,
                value: Get.isDarkMode,
                onChanged: (value) {
                  Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0ED2F7),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () => Get.to(() => const AddEditStudentScreen()),
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
      ),
    );
  }
}
