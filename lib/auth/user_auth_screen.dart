import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/auth/register_screen.dart';
import '/screens/dashboard/dashboard.dart';

class UserAuthScreen extends StatelessWidget {
  const UserAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //sign in
            return const Dashboard();
          } else {
            //is not sign in
            return const RegisterScreen();
          }
        });
  }
}
