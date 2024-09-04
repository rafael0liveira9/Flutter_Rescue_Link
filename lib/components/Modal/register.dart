import 'package:flutter/material.dart';

class RegistrationDialog extends StatelessWidget {
  final VoidCallback confirm;
  final VoidCallback close;

  const RegistrationDialog(
      {required this.confirm, required this.close, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar Atendimento'),
      content: const Text('Todos os dados estão preenchidos?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Registrar'),
          onPressed: () {
            confirm();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Voltar'),
          onPressed: () {
            close();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
