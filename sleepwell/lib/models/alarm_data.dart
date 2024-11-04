import 'dart:developer';

class AlarmData {
  // final int alarmId;
  String bedtime;
  final String optimalWakeTime;
  late String name;
  final String sensorId;
  final String userId;
  final String beneficiaryId;
  final bool isForBeneficiary;

  AlarmData({
    // required this.alarmId,
    required this.userId,
    required this.beneficiaryId,
    required this.bedtime,
    required this.optimalWakeTime,
    required this.name,
    required this.sensorId,
    required this.isForBeneficiary,
  });

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('uid')) {
      log('Warning: userId is missing in Firestore document data');
    }
    return AlarmData(
      // alarmId: json['alarmId']  ?? "0",
      userId: json['uid'] ?? "0",
      beneficiaryId: json['beneficiaryId'] ?? "0",
      bedtime: json['bedtime'] ?? '',
      optimalWakeTime: json['wakeup_time'] ?? '',
      name: json['name'] ?? '',
      sensorId: json['sensorId'] ?? '',
      isForBeneficiary: json['isForBeneficiary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bedtime': bedtime,
      'wakeup_time': optimalWakeTime,
      'name': name,
      'sensorId': sensorId,
      'uid': userId,
      'beneficiaryId': beneficiaryId,
      'isForBeneficiary': isForBeneficiary,
      // 'alarmId': alarmId,
    };
  }
}
