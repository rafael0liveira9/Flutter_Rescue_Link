import 'package:flutter/material.dart';
import 'package:flutter_health/components/datePicker.dart';
import 'package:flutter_health/components/dropDownButton.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/numberField.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:flutter_health/theme.dart';

class StepThree extends StatelessWidget {
  final void Function(int) setStep;
  final void Function(String) setHistoric;
  final List<String> historic;
  final TextEditingController hospitalizations;
  final TextEditingController medicines;
  final TextEditingController obs;

  StepThree({
    required this.setStep,
    required this.historic,
    required this.setHistoric,
    required this.hospitalizations,
    required this.medicines,
    required this.obs,
    Key? key,
  }) : super(key: key);

  String formatDocumentNumber(String number) {
    if (number.length == 11) {
      return '${number.substring(0, 3)}.${number.substring(3, 6)}.${number.substring(6, 9)}-${number.substring(9)}';
    } else {
      return number;
    }
  }

  List<dynamic> historicList = [
    'Alcoolismo',
    'Convulsões',
    'Diabetes',
    'AVC',
    'Doença Cardíaca',
    'Doença Renal',
    'Drogadição',
    'Hipertensão arterial',
    'Doença mental',
    'HIV',
    'Doença infecto contagiosa',
    'Problemas respiratórios',
    'Alergia',
    'Cirurgias',
    'Abortamento',
    'Câncer',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Histórico do Paciente',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: whiteSecondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 7.0,
                runSpacing: 7.0,
                children: historicList.map((e) {
                  return InkWell(
                    onTap: () => setHistoric(e.toString()),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                        color: historic.contains(e.toString())
                            ? thirdColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        e.toString(),
                        style: TextStyle(
                          color: historic.contains(e.toString())
                              ? Colors.white
                              : fourthColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(controller: hospitalizations, label: 'Hospitalizações:'),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(controller: medicines, label: 'Medicamentos:'),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(controller: obs, label: 'Obs:'),
        const SizedBox(
          height: 50,
        ),
        MainButton(
          onPressed: () => setStep(3),
          text: 'Próximo',
          type: '1',
        ),
        const SizedBox(
          height: 10,
        ),
        MainButton(
          onPressed: () => setStep(1),
          text: 'Voltar',
          type: '2',
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
