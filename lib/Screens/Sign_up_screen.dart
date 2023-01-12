import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/Screens/posts_screen.dart';

import '../bloc/auth_cubit.dart';
import 'Sign_In_Screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'sign_up_screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _username = '';
  String _password = '';

  late final FocusNode _PasFocusNode;
  late final FocusNode _UserNameFocusNode;

  @override
  void initState() {
    _PasFocusNode = FocusNode();
    _UserNameFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _PasFocusNode.dispose();
    _UserNameFocusNode.dispose();

    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    context
        .read<AuthCubit>()
        .signUp(email: _email, username: _username, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit,AuthState>(
        listener: (prevState, currState){
          if (currState is AuthSignUp) {

            Navigator.of(context)
                .pushReplacementNamed(PostsScreen.id);
          }
          if (currState is AuthFail) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Text(currState.massage)));
          }
        },
        builder: (context,state) {
          if(state is AuthLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return  SafeArea(
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
                          FocusScope.of(context).requestFocus(_UserNameFocusNode);
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
                      // USER NAME
                      TextFormField(
                        focusNode: _UserNameFocusNode,

                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Enter your name'),

                        textInputAction: TextInputAction.next,
                        // задает кнопку на клпвиатуре next
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_PasFocusNode);
                        },
                        onSaved: (value) {
                          _username = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter tour name';
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
                          child: Text('Sign Up')),
                      TextButton(
                          onPressed: () {
                            // TODO - Переход на sign in
                            Navigator.of(context)
                                .pushReplacementNamed(SignInScreen.id);
                          },
                          child: Text('Sign In'))
                    ],
                  ),
                ),
              ),
            ),
          );
        },


      ),
    );
  }
}
