import 'dart:convert';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import 'package:barrier_gate/function_untils/model/prename_model.dart';
import 'package:get/get.dart';

class PrenameAController extends GetxController {
  var prenames = <Prename>[].obs;
  var isLoading = false.obs;

  Future<void> getPrenames(String filter) async {
    try {
      isLoading(true);
      final value = await serviceLocator<EHPApi>().getRestAPI(
        Prename.newInstance(),
        '?$filter&${Prename.newInstance().getDefaultRestURIParam()}&\$limit=100',
      );

      prenames.value = List<Prename>.from(value.map((e) => e as Prename));

      final prefs = Get.find<SharedPreferencesControllerCenter>();
      List<String> prenameList =
          prenames.map((p) => p.prename_name ?? '').toList();
      await prefs.setStringList('prenames', prenameList);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadPrenamesFromPrefs() async {
    final prefs = Get.find<SharedPreferencesControllerCenter>();
    List<String>? savedPrenameList = await prefs.getStringList('prenames');

    if (savedPrenameList != null) {
      prenames.value =
          savedPrenameList.map((p) => Prename(null, p, null)).toList();
    } else {
      await getPrenames('active=1');
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadPrenamesFromPrefs();
  }
}
