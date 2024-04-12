import 'package:chicken_combat/presentation/interface/base_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends BaseBloc {

  RegisterBloc(BuildContext context) {
    setContext(context);
  }

  @override
  void dispose() {
    _streamUserName.close();
    _streamPassword.close();
    _streamRePassword.close();
    _errorUserName.close();
    _errorPassword.close();
    _errorRePassword.close();
    _error.close();
    _errorRegister.close();
    super.dispose();
  }

  final _streamUserName = BehaviorSubject<bool>();
  ValueStream<bool> get outputUserName => _streamUserName.stream;
  setUserName(bool event) => set(_streamUserName, event);

  final _streamPassword = BehaviorSubject<bool>();
  ValueStream<bool> get outputPassword => _streamPassword.stream;
  setPassword(bool event) => set(_streamPassword, event);

  final _streamRePassword = BehaviorSubject<bool>();
  ValueStream<bool> get outputRePassword => _streamRePassword.stream;
  setRePassword(bool event) => set(_streamRePassword, event);

  final _errorUserName = BehaviorSubject<String>();
  ValueStream<String> get outputErrorUserName => _errorUserName.stream;
  setErrorUserName(String event) => set(_errorUserName, event);

  final _errorPassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorPassword => _errorPassword.stream;
  setErrorPassword(String event) => set(_errorPassword, event);

  final _errorRePassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorRePassword => _errorRePassword.stream;
  setErrorRePassword(String event) => set(_errorRePassword, event);

  final _error = BehaviorSubject<String>();
  ValueStream<String> get outputError => _error.stream;
  setErrorString(String event) => set(_error, event);

  final _errorRegister = BehaviorSubject<String>();
  ValueStream<String> get outputErrorRegister => _errorRegister.stream;
  setErrorRegister(String event) => set(_errorRegister, event);

}