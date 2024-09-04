import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback confirm;
  final VoidCallback close;

  const ConfirmationDialog(
      {required this.confirm, required this.close, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Voltar a tela inicial?'),
      content: const Text('Todos os dados preenchidos serão perdidos.'),
      actions: <Widget>[
        TextButton(
          child: const Text('Sim'),
          onPressed: () {
            confirm();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Não'),
          onPressed: () {
            close();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
