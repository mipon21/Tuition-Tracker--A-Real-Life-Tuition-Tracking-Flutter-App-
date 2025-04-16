import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_management/controllers/general_controller.dart';
import 'package:student_management/models/teacher_model.dart';
import 'package:student_management/screens/general_screen.dart';
import 'package:student_management/theme/theme.dart';
import 'models/student_model.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(TeacherModelAdapter());
  await Hive.openBox<StudentModel>('students');
  await Hive.openBox<TeacherModel>('teachers');

  // ✅ Open a settings box for first-time launch tracking
  final settingsBox = await Hive.openBox('settings');

  // ✅ Check if this is the first launch
  bool isFirstLaunch = settingsBox.get('isFirstLaunch', defaultValue: true);

  // ✅ Set it to false after first use
  if (isFirstLaunch) {
    await settingsBox.put('isFirstLaunch', false);
  }

  runApp(MyApp(showGeneralScreen: isFirstLaunch));
}


class MyApp extends StatelessWidget {
  final bool showGeneralScreen;

  MyApp({super.key, required this.showGeneralScreen});

  final GeneralController generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tuition Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MAppTheme.lightTheme,
      darkTheme: MAppTheme.darkTheme,
      home: showGeneralScreen ? const GeneralScreen() : const HomeScreen(),
    );
  }
}

