import 'package:get/get.dart';

class GeneralController extends GetxController{
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    update();
  }
  
}