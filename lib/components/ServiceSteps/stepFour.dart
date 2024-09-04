import 'package:flutter/material.dart';
import 'package:flutter_health/components/datePicker.dart';
import 'package:flutter_health/components/dropDownButton.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/numberField.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:flutter_health/theme.dart';

class StepFour extends StatelessWidget {
  final void Function(int) setStep;
  final String airways;
  final String breathing;
  final String pulse;
  final String perfusion;
  final String skin;
  final String edema;
  final String eyeOpening;
  final String motorResponse;
  final String verbalResponse;
  final String breathingResponse;
  final String maxPA;
  final String comaScale;
  final void Function(String, String) setChangedStep4;
  final void Function() register;

  StepFour({
    required this.setStep,
    required this.airways,
    required this.breathing,
    required this.pulse,
    required this.perfusion,
    required this.skin,
    required this.edema,
    required this.motorResponse,
    required this.eyeOpening,
    required this.verbalResponse,
    required this.breathingResponse,
    required this.maxPA,
    required this.comaScale,
    required this.setChangedStep4,
    required this.register,
    Key? key,
  }) : super(key: key);

  String formatDocumentNumber(String number) {
    if (number.length == 11) {
      return '${number.substring(0, 3)}.${number.substring(3, 6)}.${number.substring(6, 9)}-${number.substring(9)}';
    } else {
      return number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              'Respiração',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownField(
                  options: const [
                    'Livre',
                    'Obstrução parcial',
                    'Obstrução total',
                    'Corpo estranho',
                    'Bronco aspiração',
                  ],
                  label: 'Vias aéreas',
                  onChanged: (e) => setChangedStep4(e.toString(), 'airways')),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: DropdownField(
                  options: const [
                    'Expontânea',
                    'Dificuldade respiratória',
                    'Parada respiratória',
                    'Ritmo irregular',
                    'Assistida',
                  ],
                  label: 'Ventilação',
                  onChanged: (e) => setChangedStep4(e.toString(), 'breathing')),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              'Circulação',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownField(
                  options: const [
                    'Regular',
                    'Irregular',
                    'Fino',
                    'Cheio',
                    'Ausente',
                  ],
                  label: 'Pulso',
                  onChanged: (e) => setChangedStep4(e.toString(), 'pulse')),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: DropdownField(
                  options: const [
                    'Normal',
                    'Retardada',
                    'Ausente',
                  ],
                  label: 'Perfusão',
                  onChanged: (e) => setChangedStep4(e.toString(), 'perfusion')),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownField(
                  options: const [
                    'Normal',
                    'Palidez',
                    'Cianose',
                    'Quente',
                    'Fria',
                    'Úmida',
                    'Seca',
                  ],
                  label: 'Pele',
                  onChanged: (e) => setChangedStep4(e.toString(), 'skin')),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: DropdownField(
                  options: const [
                    'Ausente',
                    'Palpebrau',
                    'M. Inferiores',
                    'Anasarca',
                  ],
                  label: 'Edema',
                  onChanged: (e) => setChangedStep4(e.toString(), 'edema')),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              'Escala de Coma',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownField(
                  options: const [
                    'Espontanea',
                    'A voz',
                    'A dor',
                    'Ausente',
                  ],
                  label: 'Abertura dos olhos',
                  onChanged: (e) =>
                      setChangedStep4(e.toString(), 'eyeOpening')),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: DropdownField(
                options: const [
                  'Orientado',
                  'Confuso',
                  'Desconexo',
                  'Incompreensível',
                  'Ausente',
                ],
                label: 'Resposta Verbal',
                onChanged: (e) =>
                    setChangedStep4(e.toString(), 'verbalResponse'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownField(
          options: const [
            'Obedece comando',
            'Localiza a dor',
            'Retirada a dor',
            'Flexão',
            'Extensão',
            'Ausente',
          ],
          label: 'Resposta Motora',
          onChanged: (e) => setChangedStep4(e.toString(), 'motorResponse'),
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              'Escala de Trauma',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownField(
                  options: const [
                    '+ 31',
                    '11 à 30',
                    '6 à 10',
                    '1 à 5',
                    '0',
                  ],
                  label: 'Respiração',
                  onChanged: (e) =>
                      setChangedStep4(e.toString(), 'breathingResponse')),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: DropdownField(
                options: const [
                  '+ 90',
                  '76 à 89',
                  '50 à 75',
                  '1 à 49',
                  '0',
                ],
                label: 'P.A Máxima',
                onChanged: (e) => setChangedStep4(e.toString(), 'maxPA'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownField(
          options: const [
            '13 à 15',
            '9 à 12',
            '6 à 8',
            '4 ou 5',
            '3',
          ],
          label: 'Escala coma',
          onChanged: (e) => setChangedStep4(e.toString(), 'comaScale'),
        ),
        const SizedBox(
          height: 30,
        ),
        MainButton(
          onPressed: register,
          text: 'Registrar',
          type: '1',
        ),
        const SizedBox(
          height: 10,
        ),
        MainButton(
          onPressed: () => setStep(3),
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
