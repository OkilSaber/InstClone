import 'package:flutter/material.dart';
import 'package:instaclone/Auth/login.dart';
import 'package:instaclone/Auth/register.dart';

class AuthSwitch extends StatefulWidget {
  const AuthSwitch({Key? key}) : super(key: key);

  @override
  State<AuthSwitch> createState() => _AuthSwitchState();
}

class _AuthSwitchState extends State<AuthSwitch> {
  bool isOnLogin = true;

  @override
  Widget build(BuildContext context) => isOnLogin
      ? LoginPage(onClickToSignUp: toggle)
      : RegisterPage(onClickToLogin: toggle);
  void toggle() => setState(() => isOnLogin = !isOnLogin);
}
