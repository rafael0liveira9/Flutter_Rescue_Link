import 'dart:convert';
import 'package:flutter_health/app/controller/userRepositoty.dart';
import 'package:flutter_health/app/model/userModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserRepository _userRepository = UserRepository();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> saveLocalUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toMap());
    await prefs.setString('userData', userJson);
  }

  void _showToast(String msg, bool status) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: status ? 3 : 2,
      backgroundColor: status == true ? thirdColor : redUrgency,
      textColor: whiteSecondary,
      fontSize: 16.0,
    );
  }

  // LOGIN USUARIO
  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      UserModel loginUser = UserModel(
          email: _emailController.text, password: _passwordController.text);

      UserModel? createdUser = await _userRepository.loginUser(loginUser);

      if (createdUser != null) {
        setState(() {
          _isLoading = false;
        });

        _showToast('Bem vindo(a) ${createdUser.name}', true);
        print('Usuário logado com sucesso: ${createdUser}');

        print(createdUser.toMap());
        await saveLocalUser(createdUser);
        print('Usuário salvo no SharedPreferences.');

        Navigator.of(context).pushReplacementNamed('/');
        return;
      } else {
        _showToast('Erro logar o usuário. Tente novamente.', false);
        print('Erro ao logar o usuário.');
      }
    } else {
      _showToast('Preencha todos os dados.', false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  width: 280,
                  image: AssetImage('assets/images/logo-2.png'),
                )
              ],
            ),
            Flexible(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: whiteSecondary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 80.0, 15.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Login', style: TextStyle(fontSize: 24)),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                labelText: 'E-mail',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _isObscured,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                labelText: 'Senha',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured = !_isObscured;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          ElevatedButton(
                            onPressed: _loginUser,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: thirdColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 10,
                            ),
                            child: const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                              child: Text('ENTRAR'),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/register');
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Theme.of(context).shadowColor,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 5,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(7.0, 8.0, 7.0, 8.0),
                              child: Text('CADASTRAR'),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: () => _showToast(
                                'Essa opção ainda não foi implementada.', true),
                            child: Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).shadowColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
