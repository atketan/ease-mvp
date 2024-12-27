import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/models/app_user_configuration.dart';

class FirestoreAppUserConfigurationDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUserConfiguration?> getAppUserConfiguration(String userId) async {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(userId).get();
    if (documentSnapshot.exists) {
      return AppUserConfiguration.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Future<void> saveAppUserConfiguration(
  //     String userId, AppUserConfiguration appUserConfiguration) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .set(appUserConfiguration.toJson());
  // }
}
