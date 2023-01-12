import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/Screens/posts_screen.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';

import 'Sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in_screen';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  late final FocusNode _PasFocusNode;

  @override
  void initState() {
    _PasFocusNode = FocusNode();

    super.initState();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    context.read<AuthCubit>().signIn(email: _email, password: _password);
  }

  @override
  void dispose() {
    _PasFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (prevState, currentState) {
        if (currentState is AuthSignIn) {
          Navigator.of(context)
              .pushReplacementNamed(PostsScreen.id);
        }
        if (currentState is AuthFail) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              content: Text(currentState.massage)));
        }
      }, builder: (context, state) {
        if (state is AuthLoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Form(
            key: _formKey, // ключ от нашей формы
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text('Social Media App',
                          style: Theme.of(context).textTheme.headline3),
                    ),
                    SizedBox(height: 15),
                    // EMAIL
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      // задаем значение клавиатуры

                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Enter your email'),

                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_PasFocusNode);
                      },
                      onSaved: (value) {
                        _email = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter tour email';
                        }
                        return null; // если все хорошо
                      },
                    ),

                    SizedBox(height: 15),
                    //PASSWORD
                    TextFormField(
                      focusNode: _PasFocusNode,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Enter your password'),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      onFieldSubmitted: (_) {
                        _submit(context);
                      },
                      onSaved: (value) {
                        _password = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter tour password';
                        }
                        if (value.length < 5) {
                          // указывает минимальное значение цифр
                          return 'Please enter longer password';
                        }
                        return null; // если все хорошо
                      },
                    ),
                    SizedBox(height: 15),

                    TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: Text('Sign In')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.id);
                        },
                        child: Text('Sign Up'))
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
