import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth_service.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  final void Function() onTap;
  LoginPage({required this.onTap});
  
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    AuthService authService = AuthService();
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Please fill in both fields'),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );
      return;
    }
    try {
      await authService.signInWithEmailPassword(emailController.text, passwordController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_open, size: 100, color: Theme.of(context).colorScheme.inversePrimary),
          SizedBox(height: 25),
          Text('Food Delivery App', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary)),
          SizedBox(height: 25),
          MyTextField(controller: emailController, hintText: 'Enter the email', obscureText: false),
          SizedBox(height: 10),
          MyTextField(controller: passwordController, hintText: 'Enter the password', obscureText: true),
          SizedBox(height: 15),
          MyButton(onTap: login, text: 'Sign-In'),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not a member?', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(' Register now', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
