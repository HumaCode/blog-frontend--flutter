import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:flutter_blog_laravel/models/api_response.dart';
import 'package:flutter_blog_laravel/models/user.dart';
import 'package:flutter_blog_laravel/screens/home.dart';
import 'package:flutter_blog_laravel/screens/register.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  // panggil function login user
  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);

    // jika tidak error maka
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    // redirect to home
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              style: const TextStyle(
                fontSize: 20,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: kInputDecoration('Email'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              style: const TextStyle(
                fontSize: 20,
              ),
              controller: txtPassword,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Required at least 6 chars' : null,
              decoration: kInputDecoration('password'),
            ),
            const SizedBox(height: 10),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton('Login', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }

                    // debugPrint(txtPassword.text);
                  }),
            const SizedBox(height: 10),
            kLoginRegister('Dont have an account? ', 'Register', () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
