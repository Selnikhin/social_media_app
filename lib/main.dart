import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/Screens/posts_screen.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';

import 'Screens/Sign_In_Screen.dart';
import 'Screens/Sign_up_screen.dart';
//import 'package:social_media_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(

        theme: ThemeData.dark(),
        home: SignUpScreen(),
        // создадим именные routes
        routes: {
          SignInScreen.id: (context) => SignInScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          PostsScreen.id: (context) => PostsScreen(),
        },
      ),
    );
  }
}

