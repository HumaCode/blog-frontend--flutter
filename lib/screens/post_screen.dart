import 'package:flutter/material.dart';

class PostScreenPage extends StatefulWidget {
  const PostScreenPage({Key? key}) : super(key: key);

  @override
  State<PostScreenPage> createState() => _PostScreenPageState();
}

class _PostScreenPageState extends State<PostScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Post'),
      ),
    );
  }
}
