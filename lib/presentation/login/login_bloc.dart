import 'package:chicken_combat/presentation/interface/base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BaseBloc {
  LoginBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    _streamPassword.close();
    _streamUserName.close();
    _errorUserName.close();
    _errorPassword.close();
    _error.close();
    super.dispose();
  }

  final _streamPassword = BehaviorSubject<bool>();
  ValueStream<bool> get outputPassword => _streamPassword.stream;
  setPassword(bool event) => set(_streamPassword, event);

  final _streamUserName = BehaviorSubject<bool>();
  ValueStream<bool> get outputUserName => _streamUserName.stream;
  setUserName(bool event) => set(_streamUserName, event);

  final _errorUserName = BehaviorSubject<String>();
  ValueStream<String> get outputErrorUserName => _errorUserName.stream;
  setErrorPassword(String event) => set(_errorPassword, event);

  final _errorPassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorPassword => _errorPassword.stream;
  setErrorUserName(String event) => set(_errorUserName, event);

  final _error = BehaviorSubject<String>();
  ValueStream<String> get outputError => _error.stream;
  setErrorString(String event) => set(_error, event);
}