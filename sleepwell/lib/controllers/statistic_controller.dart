import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/statistic_model.dart';

class StatisticController extends GetxController {
  final String beneficiaryId; // معرف التابع
  late final StatisticModel _model;

  StatisticController({required this.beneficiaryId}) {
    // تمرير معرف التابع عند إنشاء الكلاس
    _model = StatisticModel(beneficiaryId: beneficiaryId);
  }

  var sleepHoursDurationLastDay = ''.obs;
  var sleepTimeActualLastDay = ''.obs;
  var sleepCyclesLastDay = ''.obs;
  var wakeUpTimeLastDay = ''.obs;
  var sleepCycleDataLastDay = <FlSpot>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDayData();
  }

  Future<void> loadDayData() async {
    try {
      final data = await _model.fetchDayData();

      // طباعة البيانات التي تم جلبها
      print('Fetched data: $data');

      // البيانات قد تكون String أو DateTime
      var bedtime = data['bedtime'];
      var wakeupTime = data['wakeupTimeObj'];

      // طباعة أوقات النوم والاستيقاظ
      print('Bedtime: $bedtime');
      print('Wakeup Time: $wakeupTime');

      // عرض الوقت بصيغة AM/PM
      sleepTimeActualLastDay.value = DateFormat('h:mm a').format(bedtime);
      wakeUpTimeLastDay.value = DateFormat('h:mm a').format(wakeupTime);

      sleepHoursDurationLastDay.value = data['sleepHoursDuration'];
      sleepCyclesLastDay.value = data['sleepCycles'];

      // طباعة عدد ساعات النوم وعدد الدورات
      print('Sleep Hours Duration: ${sleepHoursDurationLastDay.value}');
      print('-----------------::::::::::::::::::::;==========');
      print('Sleep Cycles: ${sleepCyclesLastDay.value}');

      // طباعة بيانات الدورات الناتجة
      print('Generated Sleep Cycle Data: ${sleepCycleDataLastDay.value}');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // دالة للتحقق مما إذا كانت القيمة DateTime أو String وتحويلها إذا لزم الأمر
  DateTime _ensureDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    } else if (value is String) {
      try {
        return DateFormat('h:mm a').parse(value);
      } catch (e) {
        print('Error parsing time: $e');
        throw e; // أعد رمي الخطأ لتحديد أن التحويل فشل
      }
    } else {
      throw Exception('Unsupported data type for time value: $value');
    }
  }
}
