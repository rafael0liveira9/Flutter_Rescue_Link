import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health/app/controller/userRepositoty.dart';
import 'package:flutter_health/app/model/userModel.dart';
import '../../theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserRepository _userRepository = UserRepository();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  var _typeController = 1;

  bool _isObscured = true;
  bool _passwordMatch = false;
  bool _nameValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _passwordEspecialValid = false;
  bool _passwordUpperCaseValid = false;
  bool _passwordSizeValid = false;
  bool _passwordNumberValid = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_nameCheck);
    _emailController.addListener(_emailCheck);
    _passwordController.addListener(_checkPasswordMatch);
    _passwordController.addListener(_passwordCheck);
    _confirmPasswordController.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> saveLocalUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toMap());
    await prefs.setString('userData', userJson);
  }

// CRIAR USUARIO
  void _createNewUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameValid &&
        _emailValid &&
        _passwordValid &&
        _passwordMatch) {
      final jobStateType =
          _typeController == 1 ? 'Ambulância' : 'Pronto Atendimento';

      UserModel newUser = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        type: 1,
        jobStateType: jobStateType,
      );

      UserModel? createdUser = await _userRepository.createUser(newUser);

      if (createdUser != null) {
        if (createdUser.name == 'Usuário já cadatrado') {
          _showToast('Email já cadatrado. Faça o Login.', false);
          Navigator.of(context).pushReplacementNamed('/login');
          return null;
        }

        setState(() {
          _isLoading = false;
        });

        _showToast('Bem vindo(a) ${createdUser.name}', false);

        await saveLocalUser(createdUser);
        print('Usuário salvo no SharedPreferences.');

        Navigator.of(context).pushReplacementNamed('/');
        return null;
      } else {
        _showToast('Erro ao criar o usuário. Tente novamente.', false);
        print('Erro ao criar o usuário.');
      }
    } else {
      _showToast('Preencha todos os dados.', false);
    }
    setState(() {
      _isLoading = false;
    });
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

  void _typePress(type) {
    setState(() {
      if (_typeController != type) {
        _typeController = type;
      }
    });
  }

  void _checkPasswordMatch() {
    setState(() {
      _passwordMatch = _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _nameCheck() {
    setState(() {
      if (_nameController.text.isNotEmpty) {
        _nameValid = _nameController.text.length > 3;
      } else {
        _nameValid = true;
      }
    });
  }

  void _emailCheck() {
    setState(() {
      if (_emailController.text.isNotEmpty) {
        String email = _emailController.text.toLowerCase();

        String pattern =
            r'^[a-zA-Z0-9_\-$&*#]{2,}@[a-zA-Z0-9]{3,}\.[a-zA-Z]{2,}(?:\.[a-zA-Z]{2,})?$';
        RegExp regex = RegExp(pattern);

        _emailValid = regex.hasMatch(email);
      } else {
        _emailValid = false;
      }
    });
  }

  void _passwordCheck() {
    if (_passwordController.text.isNotEmpty) {
      setState(() {
        String password = _passwordController.text;

        _passwordSizeValid = password.length >= 6;

        _passwordUpperCaseValid = RegExp(r'[A-Z]').hasMatch(password);

        _passwordEspecialValid =
            RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

        _passwordNumberValid = RegExp(r'[0-9]').hasMatch(password);

        _passwordValid = _passwordSizeValid &&
            _passwordUpperCaseValid &&
            _passwordEspecialValid &&
            _passwordNumberValid;
      });
    } else {
      _passwordValid = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      width: 280,
                      image: AssetImage('assets/images/logo-2.png'),
                    )
                  ],
                ),
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
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Inscreva-se',
                                style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 40.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 0.0, 15.0, 0.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () => _typePress(1),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: _typeController == 1
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                        backgroundColor: _typeController == 1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 12.0,
                                        ),
                                      ),
                                      child: const Text(
                                        'Ambulância',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () => _typePress(2),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: _typeController == 2
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                        backgroundColor: _typeController == 2
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 12.0,
                                        ),
                                      ),
                                      child: const Text(
                                        'Pronto Atendimento',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            _buildTextField(
                              controller: _nameController,
                              label: 'Nome',
                              isValid: _nameValid,
                            ),
                            const SizedBox(height: 10.0),
                            _buildTextField(
                              controller: _emailController,
                              label: 'E-mail',
                              isValid: _emailValid,
                            ),
                            const SizedBox(height: 10.0),
                            _buildPasswordField(
                              controller: _passwordController,
                              isObscured: _isObscured,
                              isValid: _passwordValid,
                            ),
                            const SizedBox(height: 10.0),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              isObscured: _isObscured,
                              isValid: _passwordMatch,
                              label: 'Confirmar Senha',
                            ),
                            const SizedBox(height: 10.0),
                            _buildValidationMessages(),
                            const SizedBox(height: 40.0),
                            if (_isLoading == false)
                              Column(
                                children: [
                                  _buildSaveButton(),
                                  const SizedBox(height: 10.0),
                                  _buildBackButton(context),
                                  const SizedBox(height: 100.0),
                                ],
                              )
                            else
                              CircularProgressIndicator()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isValid,
  }) {
    return Container(
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
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          labelText: label,
          suffixIcon: Icon(
            controller.text.isNotEmpty
                ? isValid
                    ? Icons.check
                    : Icons.close
                : null,
            color: isValid ? Colors.green : Colors.red,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscured,
    required bool isValid,
    String label = 'Senha',
  }) {
    return Container(
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
        controller: controller,
        obscureText: isObscured,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          labelText: label,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.text.isNotEmpty
                      ? isValid
                          ? Icons.check
                          : Icons.close
                      : null,
                  color: isValid ? Colors.green : Colors.red,
                  size: 30.0,
                ),
                if (label != 'Confirmar Senha')
                  IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_nameController.text.isNotEmpty && _nameValid == false)
                _buildValidationCard('* Digite um Nome valido'),
              if (_emailController.text.isNotEmpty && _emailValid == false)
                _buildValidationCard('* Digite um E-mail valido'),
              if (_passwordController.text.isNotEmpty &&
                  _passwordUpperCaseValid == false)
                _buildValidationCard('* Falta caractere Maiúsculo'),
              if (_passwordController.text.isNotEmpty &&
                  _passwordEspecialValid == false)
                _buildValidationCard('* Falta caractere Especial'),
              if (_passwordController.text.isNotEmpty &&
                  _passwordNumberValid == false)
                _buildValidationCard('* Falta caractere Numérico'),
              if (_passwordController.text.isNotEmpty &&
                  _passwordSizeValid == false)
                _buildValidationCard('* Precisa ter pelo menos 6 digitos'),
              if (_passwordController.text.isNotEmpty &&
                  _confirmPasswordController.text.isNotEmpty &&
                  _passwordMatch == false)
                _buildValidationCard('* As senhas não coincidem'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValidationCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 3.0, 20.0, 3.0),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _createNewUser,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 5.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 10,
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
        child: Text('SALVAR'),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).shadowColor,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 5.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 8,
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(1.0, 3.0, 12.0, 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.keyboard_arrow_left),
            SizedBox(width: 2.0),
            Text('VOLTAR'),
          ],
        ),
      ),
    );
  }
}
