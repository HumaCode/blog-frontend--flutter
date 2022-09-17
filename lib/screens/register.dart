import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:flutter_blog_laravel/models/api_response.dart';
import 'package:flutter_blog_laravel/models/user.dart';
import 'package:flutter_blog_laravel/screens/home.dart';
import 'package:flutter_blog_laravel/screens/login.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //
  final GlobalKey<FormState> formkey = GlobalKey();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  // panggil function register user
  void _registerUser() async {
    ApiResponse response = await registerUser(
        nameController.text, emailController.text, passwordController.text);

    // jika tidak error maka
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('user_id', 0);

    // redirect to home
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
              keyboardType: TextInputType.text,
              controller: nameController,
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              decoration: kInputDecoration('Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              style: const TextStyle(
                fontSize: 20,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: kInputDecoration('Email'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              style: const TextStyle(
                fontSize: 20,
              ),
              controller: passwordController,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Required at least 6 chars' : null,
              decoration: kInputDecoration('Password'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              style: const TextStyle(
                fontSize: 20,
              ),
              controller: passwordConfirmController,
              obscureText: true,
              validator: (val) => val != passwordController.text
                  ? 'Confirm password does not match'
                  : null,
              decoration: kInputDecoration('Confirm password'),
            ),
            const SizedBox(height: 10),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton('Register', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = !loading;
                        _registerUser();
                      });
                    }

                    // debugPrint(txtPassword.text);
                  }),
            const SizedBox(height: 10),
            kLoginRegister('Already have an account? ', 'Login', () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
