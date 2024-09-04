import 'package:flutter/material.dart';

class ConcludeDialog extends StatelessWidget {
  final VoidCallback confirm;
  final VoidCallback close;

  const ConcludeDialog({required this.confirm, required this.close, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deseja concluir o atendimento?'),
      content: const Text(
          'É uma ação irreversível, após concluir, não poderá mais editar dados do atendimento.'),
      actions: <Widget>[
        TextButton(
          child: const Text('Concluir'),
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
