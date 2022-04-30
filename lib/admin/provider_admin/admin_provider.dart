import 'package:cloud_firestore/cloud_firestore.dart';

import '/utils/constrains.dart';

class AdminProvider {
  static String email = '';

  // admin email
  static String getAdminEmail() {
    UserRepo.ref
        .collection('Admin')
        .doc(email)
        .get()
        .then((DocumentSnapshot value) {});
    return email;
  }
}
