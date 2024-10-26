import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAlarm(String bedtime, String wakeupTime, String cycles,
      String userId, String? beneficiaryId, bool isForBeneficiary) async {
    await _firestore.collection('alarms').add({
      'bedtime': bedtime,
      'wakeup_time': wakeupTime,
      'num_of_cycles': cycles,
      'added_day': DateTime.now().day,
      'added_month': DateTime.now().month,
      'added_year': DateTime.now().year,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': userId,
      'beneficiaryId': beneficiaryId,
      'isForBeneficiary': isForBeneficiary,
    });
  }
}
