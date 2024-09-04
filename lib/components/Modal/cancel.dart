import 'package:flutter/material.dart';

class CancelDialog extends StatelessWidget {
  final VoidCallback confirm;
  final VoidCallback close;

  const CancelDialog({required this.confirm, required this.close, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deseja cancelar o atendimento?'),
      content: const Text(
          'É uma ação irreversível, após cancelar, não poderá mais editar dados do atendimento.'),
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
