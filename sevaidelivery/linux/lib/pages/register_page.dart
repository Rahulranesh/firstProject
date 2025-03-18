import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth_service.dart';


class RegisterPage extends StatefulWidget {
  final void Function() onTap;
  RegisterPage({required this.onTap});
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    AuthService authService = AuthService();
    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Passwords do not match'),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );
      return;
    }
    try {
      await authService.signUpWithEmailPassword(emailController.text, passwordController.text);
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
          Text("Let's create an account", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary)),
          SizedBox(height: 25),
          MyTextField(controller: emailController, hintText: 'Enter the email', obscureText: false),
          SizedBox(height: 10),
          MyTextField(controller: passwordController, hintText: 'Enter the password', obscureText: true),
          SizedBox(height: 10),
          MyTextField(controller: confirmPasswordController, hintText: 'Confirm password', obscureText: true),
          SizedBox(height: 15),
          MyButton(onTap: register, text: 'Sign-Up'),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(' Login now', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
