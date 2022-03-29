import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:roomie/main.dart';
import 'package:roomie/styles.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

const users = {
  'testi': '12345',
};

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signUp(SignupData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: FlutterLogin(
          theme: LoginTheme(
              pageColorLight: Colors.white,
              pageColorDark: Colors.pink.shade100,
              primaryColor: Styles.primaryRed),
          userType: LoginUserType.name,
          messages: LoginMessages(userHint: 'Username'),
          onLogin: _authUser,
          logo: const AssetImage('assets/image/logo.png'),
          userValidator: (value) {
            return null;
          },
          savedEmail: 'testi',
          savedPassword: '12345',
          onSignup: (data) {
            return _signUp(data);
          },
          passwordValidator: (value) {
            if (value!.isEmpty) {
              return 'Password is empty';
            }
            return null;
          },
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const MainPage(),
            ));
          },
          onRecoverPassword: _recoverPassword,
        ));
  }
}
