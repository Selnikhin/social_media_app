part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object> get props => [];
}
class AuthLoadingState extends AuthState {
  const AuthLoadingState();

  @override
  List<Object> get props => [];
}
class AuthSignUp extends AuthState {
  const AuthSignUp();

  @override
  List<Object> get props => [];
}
class AuthSignIn extends AuthState {
  const AuthSignIn();

  @override
  List<Object> get props => [];
}

class AuthFail extends AuthState {

  final String  massage;

  const AuthFail(
  {required this.massage}
      );

  @override
  List<Object> get props => [massage];
}