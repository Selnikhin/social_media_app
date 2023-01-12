import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignIn());
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFail(massage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFail(massage: 'Wrong password provided for that user.'));
      }
    } catch (error) {
      emit(AuthFail(massage: 'An error has occurred'));
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(AuthLoadingState());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        "userID": userCredential.user!.uid,
        'userName': username,
        "email": email,
      });



      emit(AuthSignUp());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFail(massage:'the password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthFail(massage:'The account already exists for that email. '));
      }
    } catch (error) {
      emit(AuthFail(massage: 'An error has occurred...'));
    }
  }
}
