import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:flutter_blog_laravel/models/api_response.dart';
import 'package:flutter_blog_laravel/models/user.dart';
import 'package:flutter_blog_laravel/screens/login.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({Key? key}) : super(key: key);

  @override
  State<ProfileScreenPage> createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends State<ProfileScreenPage> {
  User? user;
  bool loading = true;
  TextEditingController txtNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? image;

  // image picker
  Future<File?> getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
      // ignore: empty_catches
    } catch (e) {}
    return image;
  }

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      // nanti diganti dengan snackbar
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false),
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  //  update profile
  void updateProfile() async {
    ApiResponse response =
        await updateUser(txtNameController.text, getStringImage(image));

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthorized) {
      // nanti diganti dengan snackbar
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false),
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: image == null
                            ? user!.image != null
                                ? DecorationImage(
                                    image: NetworkImage('${user!.image}'),
                                    fit: BoxFit.cover,
                                  )
                                : null
                            : DecorationImage(
                                image: FileImage(
                                  image ?? File(''),
                                ),
                                fit: BoxFit.cover,
                              ),
                        color: Colors.amber,
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: kInputDecoration('Name'),
                    controller: txtNameController,
                    validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                  ),
                ),
                const SizedBox(height: 20),
                kTextButton('Update', () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    updateProfile();
                  }
                })
              ],
            ),
          );
  }
}
