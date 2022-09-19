import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:flutter_blog_laravel/models/api_response.dart';
import 'package:flutter_blog_laravel/models/post.dart';
import 'package:flutter_blog_laravel/screens/login.dart';
import 'package:flutter_blog_laravel/services/post_service.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;
  final String? title;

  const PostFormPage({
    Key? key,
    this.post,
    this.title,
  }) : super(key: key);

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

  // function create post
  void _createPost() async {
    String? img = image == null ? null : getStringImage(image);

    ApiResponse response = await createPost(_txtControllerBody.text, img);

    if (response.error == null) {
      Navigator.pop(context);
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

      setState(() {
        loading = !loading;
      });
    }
  }

  // function edit post
  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, _txtControllerBody.text);

    if (response.error == null) {
      Navigator.pop(context);
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

      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      _txtControllerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                widget.post != null
                    ? const SizedBox()
                    : Container(
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

                        if (widget.post == null) {
                          _createPost();
                        } else {
                          _editPost(widget.post!.id ?? 0);
                        }
                      }
                    });
                  }),
                )
              ],
            ),
    );
  }
}
