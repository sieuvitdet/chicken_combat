

import 'package:chicken_combat/presentation/interface/base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc extends BaseBloc {
  ChangePasswordBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    _streamPassword.close();
    _streamNewPassword.close();
    _streamAgainPassword.close();
    _errorPassword.close();
    _errorNewPassword.close();
    _errorAgainPassword.close();
    _error.close();
    _errorChangePassword.close();
    super.dispose();
  }

  final _streamPassword = BehaviorSubject<bool>();
  ValueStream<bool> get outputPassword => _streamPassword.stream;
  setPassword(bool event) => set(_streamPassword, event);

  final _streamNewPassword = BehaviorSubject<bool>();
  ValueStream<bool> get outputNewPassword => _streamNewPassword.stream;
  setNewPassword(bool event) => set(_streamNewPassword, event);

  final _streamAgainPassword = BehaviorSubject<bool>();
  ValueStream<bool> get outputAgainPassword => _streamAgainPassword.stream;
  setAgainPassword(bool event) => set(_streamAgainPassword, event);

  final _errorPassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorPassword => _errorPassword.stream;
  setErrorPassword(String event) => set(_errorPassword, event);

    final _errorNewPassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorNewPassword => _errorNewPassword.stream;
  setErrorNewPassword(String event) => set(_errorNewPassword, event);

    final _errorAgainPassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorAgainPassword => _errorAgainPassword.stream;
  setErrorAgainPassword(String event) => set(_errorAgainPassword, event);

  final _error = BehaviorSubject<String>();
  ValueStream<String> get outputError => _error.stream;
  setErrorString(String event) => set(_error, event);

  final _errorChangePassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorChangePassword => _errorChangePassword.stream;
  setErrorChangePassword(String event) => set(_errorChangePassword, event);


}