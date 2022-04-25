import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../utils/constrains.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SignInScreen(
            headerBuilder: (context, constraints, _) {
              return Center(
                child: Text(
                  'Welcome to ' + kBrandName,
                  style: Theme.of(context).textTheme.headline5,
                ),
              );
            },
            providerConfigs: const [
              EmailProviderConfiguration(),
            ]),
      ),
    );
  }
}
