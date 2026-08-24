import 'dart:convert';import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<void> persistAccount(UserModel user);
  Future<List<UserModel>> getRegisteredAccounts();
}

const CACHED_USER = 'CACHED_USER';
const REGISTERED_ACCOUNTS = 'REGISTERED_ACCOUNTS';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(CACHED_USER, json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) return UserModel.fromJson(json.decode(jsonString));
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(CACHED_USER);
  }

  @override
  Future<void> persistAccount(UserModel user) async {
    final accounts = await getRegisteredAccounts();
    final index = accounts.indexWhere((a) => a.email.toLowerCase() == user.email.toLowerCase());

    if (index != -1) {
      accounts[index] = user;
    } else {
      accounts.add(user);
    }

    await sharedPreferences.setString(
      REGISTERED_ACCOUNTS,
      json.encode(accounts.map((a) => a.toJson()).toList()),
    );
  }

  @override
  Future<List<UserModel>> getRegisteredAccounts() async {
    final jsonString = sharedPreferences.getString(REGISTERED_ACCOUNTS);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => UserModel.fromJson(item)).toList();
    }
    return [];
  }
}