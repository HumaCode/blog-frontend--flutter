import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:flutter_blog_laravel/models/api_response.dart';
import 'package:flutter_blog_laravel/models/post.dart';
import 'package:flutter_blog_laravel/screens/login.dart';
import 'package:flutter_blog_laravel/services/post_service.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';

class PostScreenPage extends StatefulWidget {
  const PostScreenPage({Key? key}) : super(key: key);

  @override
  State<PostScreenPage> createState() => _PostScreenPageState();
}

class _PostScreenPageState extends State<PostScreenPage> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all post
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _postList.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = _postList[index];
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  image: post.user!.image == null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              '${post.user!.image}'))
                                      : null,
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${post.user!.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            ),
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
