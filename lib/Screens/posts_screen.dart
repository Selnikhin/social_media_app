import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {

  static const String id = "posts_screen";
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add)),
        ],
      ),
      body: Container(),
    );
  }
}
