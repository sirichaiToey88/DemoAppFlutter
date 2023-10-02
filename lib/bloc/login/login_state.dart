part of 'login_bloc.dart';

class LoginState extends Equatable {
  final int count;
  final bool isAuthened;
  final String token;
  final String username;
  final String email;
  final String mobile;
  final String userId;
  final List<UserDetail> user;

  const LoginState({
    required this.token,
    this.count = 0,
    this.isAuthened = false,
    required this.username,
    required this.email,
    required this.mobile,
    required this.userId,
    this.user = const [],
  });

  LoginState copywith({
    int? count,
    bool? isAuthened,
    String? token,
    List<UserDetail>? user,
  }) {
    return LoginState(
      count: count ?? this.count,
      isAuthened: isAuthened ?? this.isAuthened,
      token: token ?? this.token,
      username: username,
      email: email,
      mobile: mobile,
      user: user ?? this.user,
      userId: userId,
    );
  }

  @override
  List<Object?> get props => [
        count,
        isAuthened,
        token,
        username,
        email,
        mobile,
        user,
        userId,
      ];
}
