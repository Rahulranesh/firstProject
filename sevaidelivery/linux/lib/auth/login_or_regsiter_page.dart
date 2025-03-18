import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';


class LoginOrRegister extends StatefulWidget {
  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}
class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;
  
  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return showLogin ? LoginPage(onTap: toggle) : RegisterPage(onTap: toggle);
  }
}
