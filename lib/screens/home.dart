import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/screens/login.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false),
                });
          },
          child: const Text('Home Page : Press to logout'),
        ),
      ),
    );
  }
}
