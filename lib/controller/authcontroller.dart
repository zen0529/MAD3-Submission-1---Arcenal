import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile3_midterm/enum/enum.dart';
import 'package:mobile3_midterm/screens/logout.dart';

class AuthController with ChangeNotifier {
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get I => GetIt.instance<AuthController>();

  AuthState state = AuthState.unauthenticated;
  SimulatedAPI api = SimulatedAPI();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  login(String username, String password) async {
    bool isLoggedIn = await api.login(username, password);

    print(
        "Login attempt: username=$username, password=$password, isLoggedIn=$isLoggedIn");
    if (isLoggedIn) {
      state = AuthState.authenticated;
      //should store session
      //writing the account to secure storage
      await secureStorage.write(key: 'username', value: username);
      await secureStorage.write(key: 'password', value: password);

      //ford debugging purpose
      String? storedUsername = await secureStorage.read(key: 'username');
      String? storedPassword = await secureStorage.read(key: 'password');
      print(
          "Stored credentials: username=$storedUsername, password=$storedPassword");

      notifyListeners();
    }
  }

  logout() async {
    //should clear session
    state = AuthState.unauthenticated;
    //for debuggging purpose
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');

    print('Secure Username: $username');
    print('Secure Password: $password');

    //deleting account
    await secureStorage.delete(key: 'username');
    await secureStorage.delete(key: 'password');

    //for debuggging purpose
    String? _username = await secureStorage.read(key: 'username');
    String? _password = await secureStorage.read(key: 'password');

    print('Secure Username: $_username');
    print('Secure Password: $_password');

    notifyListeners();
  }

  loadSession() async {
    //for debugging purpose
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');

    print("Stored credentials: username=$username, password=$password");

    if (username != null && password != null) {
      try {
        bool isLoggedIn = await api.login(username, password);
        if (isLoggedIn) {
          state = AuthState.authenticated;
        }
      } catch (e) {
        print("Session load failed: $e");
      }
    }
    notifyListeners();
  }
}

class SimulatedAPI {
  Map<String, String> users = {'aldren': 'Aldren529-'};

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 4));
    if (users[username] == null) throw Exception("User does not exist");
    if (users[username] != password) throw Exception("Password does not match");
    return users[username] == password;
  }
}
