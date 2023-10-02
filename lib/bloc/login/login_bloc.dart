import 'package:bloc/bloc.dart';
import 'package:demo_app/model/user_login.dart';
import 'package:demo_app/model/user_detail.dart';
import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/main/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(const LoginState(
          token: '',
          email: '',
          mobile: '',
          username: '',
          user: [],
          userId: '',
        )) {
    //Add
    on<LoginEventAdd>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copywith(
        count: state.count + 1,
      ));
    });

    //Remove
    on<LoginEventRemove>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copywith(
        count: state.count - 1,
      ));
    });

    //Login
    // on<LoginEventLogin>((event, emit) async {
    //   await Future.delayed(Duration(seconds: 1));
    //   final token = await WebApiService().authentcateUser(
    //     event.payload.email,
    //     event.payload.mobile,
    //   );
    //   if (token != null) {
    //     emit(state.copywith(isAuthened: true));
    //     if (navigatorState.currentContext != null) {
    //       Navigator.pushReplacementNamed(
    //         navigatorState.currentContext!,
    //         AppRoute.listProduct,
    //       );
    //     }
    //   } else {
    //     emit(state.copywith(isAuthened: false));
    //   }
    // });

    on<LoginEventLogin>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));

      // Prepare the payload
      var payload = {
        'email': event.payload.email,
        'mobile': event.payload.mobile,
      };

      // Make the API request
      var response = await http.post(
        Uri.parse('http://localhost:8080/login'),
        body: json.encode(payload),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the response JSON
        var jsonResponse = json.decode(response.body);

        // Get the token from the response
        var token = jsonResponse['token'];
        List<UserDetail> data = (jsonResponse['data'] as List).map((item) => UserDetail.fromJson(item)).toList();

        emit(state.copywith(isAuthened: true, user: data, token: token));

        if (navigatorState.currentContext != null) {
          Navigator.pushReplacementNamed(
            navigatorState.currentContext!,
            AppRoute.homeUser,
          );
        }
      } else {
        emit(state.copywith(isAuthened: false));
      }
    });
  }
}
