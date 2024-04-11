import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/interface/base_bloc.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
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
  setErrorUserName(String event) => set(_errorUserName, event);

  final _errorPassword = BehaviorSubject<String>();
  ValueStream<String> get outputErrorPassword => _errorPassword.stream;
  setErrorPassword(String event) => set(_errorPassword, event);

  final _error = BehaviorSubject<String>();
  ValueStream<String> get outputError => _error.stream;
  setErrorString(String event) => set(_error, event);

  final _errorLogin = BehaviorSubject<String>();
  ValueStream<String> get outputErrorLogin => _errorLogin.stream;
  setErrorLogin(String event) => set(_errorLogin, event);

  setupLogin(UserModel responseModel) {
    Globals.prefs!.setBool(SharedPrefsKey.is_login, true);
    Globals.prefs!.setString(SharedPrefsKey.id_user, responseModel.id);
    Globals.prefs!.setString(SharedPrefsKey.username, responseModel.username);
    Globals.prefs!.setString(SharedPrefsKey.password, responseModel.password);
    Globals.prefs!.setString(SharedPrefsKey.level, responseModel.level);
    Globals.prefs!.setString(SharedPrefsKey.finance_id, responseModel.financeId);
    Globals.prefs!.setString(SharedPrefsKey.avatar, responseModel.avatar);
  }
}