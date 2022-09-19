import 'package:flutter/material.dart';
import 'package:flutter_blog_laravel/constants.dart';
import 'package:flutter_blog_laravel/models/api_response.dart';
import 'package:flutter_blog_laravel/models/comment.dart';
import 'package:flutter_blog_laravel/screens/login.dart';
import 'package:flutter_blog_laravel/services/comment_services.dart';
import 'package:flutter_blog_laravel/services/user_service.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;
  const CommentScreen({
    Key? key,
    this.postId,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  final TextEditingController _txtCommentController = TextEditingController();

  // get comment
  Future<void> _getComments() async {
    userId = await getUserId();

    ApiResponse response = await getComments(widget.postId ?? 0);

    if (response.error == null) {
      setState(() {
        _commentList = response.data as List<dynamic>;
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

// buat comment
  void _createComment() async {
    ApiResponse response =
        await createComment(widget.postId ?? 0, _txtCommentController.text);

    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
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

  // delete comment
  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComment(commentId);

    if (response.error == null) {
      _getComments();
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

  // // edit comment
  // void _editComment() async {
  //   ApiResponse response =
  //       await editComment(_editCommentId, _txtCommentController.text);

  //   if (response.error == null) {
  //     _editCommentId = 0;
  //     _txtCommentController.clear();
  //     _getComments();
  //   } else if (response.error == unauthorized) {
  //     // nanti diganti dengan snackbar
  //     logout().then((value) => {
  //           Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(builder: (context) => const LoginPage()),
  //               (route) => false),
  //         });
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('${response.error}')));
  //   }
  // }

  @override
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    child: ListView.builder(
                        itemCount: _commentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment = _commentList[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black26,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            image: comment.user!.image != null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        '${comment.user!.image}'),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${comment.user!.name}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    comment.user!.id == userId
                                        ? PopupMenuButton(
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.more_vert,
                                                color: Colors.black,
                                              ),
                                            ),
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                            onSelected: (val) {
                                              _deleteComment(comment.id!);
                                            },
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text('${comment.comment}')
                              ],
                            ),
                          );
                        }),
                    onRefresh: () {
                      return _getComments();
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: TextFormField(
                        decoration: kInputDecoration('Comment'),
                        controller: _txtCommentController,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_txtCommentController.text.isNotEmpty) {
                          setState(() {
                            _loading = true;
                          });
                          _createComment();
                        }
                      },
                      icon: const Icon(Icons.send),
                    )
                  ]),
                )
              ],
            ),
    );
  }
}
