import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModelData {
  final String bedtime;
  final String wakeupTime;
  final String numOfCycles;
  final DateTime timestamp;
  final bool isForBeneficiary;

  AlarmModelData({
    required this.bedtime,
    required this.wakeupTime,
    required this.numOfCycles,
    required this.timestamp,
    required this.isForBeneficiary,
  });

  // تحويل البيانات من Firestore DocumentSnapshot إلى Alarm object
  factory AlarmModelData.fromFirestore(Map<String, dynamic> data) {
    return AlarmModelData(
      bedtime: (data['bedtime']),
      wakeupTime: (data['wakeup_time']),
      numOfCycles: data['num_of_cycles'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isForBeneficiary: data['isForBeneficiary'],
    );
  }
}
