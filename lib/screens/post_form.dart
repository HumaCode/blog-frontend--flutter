import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:image_picker/image_picker.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({Key? key}) : super(key: key);

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool loading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: image == null
                        ? null
                        : DecorationImage(
                            image: FileImage(image ?? File('')),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        getImage();
                      },
                      icon: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _txtControllerBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (val) =>
                          val!.isEmpty ? 'Post body is required' : null,
                      decoration: const InputDecoration(
                        hintText: 'Post Body..',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black38),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: kTextButton('Post', () {
                    setState(() {
                      if (_formkey.currentState!.validate()) {
                        loading = !loading;
                      }
                    });
                  }),
                )
              ],
            ),
    );
  }
}
