import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/login_auth/register_page.dart';
import 'package:task_manager/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Task Manager')),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Card(
                  color: Colors.lightBlue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30),
                      Container(
                        child: Text(
                          'Email',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: Text(
                          'Password',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, shape: StadiumBorder()),
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                          onPressed: () {
                            AuthController.instance.login(
                                emailController.text.trim(),
                                passwordController.text.trim());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent, shape: StadiumBorder()),
                    onPressed: () {
                      Get.to(RegisterPage());
                    },
                    child: Text('Sign Up')),
              )
            ],
          ),
        ));
  }
}
