import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Card(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30),
                      Container(
                        child: Text(
                          'Name',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextField(
                          controller: nameController,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: Text(
                          'Email',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 70,
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
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, shape: StadiumBorder()),
                          child: Text(
                            'Sign Up !',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            AuthController.instance.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                nameController.text.trim());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
