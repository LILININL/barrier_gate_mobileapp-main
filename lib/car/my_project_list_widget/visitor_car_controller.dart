import 'package:get/get.dart';

class VisitorCarController extends GetxController {
  var vehicleVisitorStatusId = ''.obs;

  void setVehicleVisitorStatusId(String id) {
    vehicleVisitorStatusId.value = id;
    update(); // บังคับให้ Widget ที่ผูกกับ GetBuilder อัปเดต
  }
}
