import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '/auth/user_auth_screen.dart';
import 'firebase_options.dart';
import 'utils/constrains.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kBrandName,
      theme: myThemeData(),
      home: const UserAuthScreen(),
    );
  }
}
