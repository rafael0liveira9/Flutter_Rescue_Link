import 'package:flutter/material.dart';
import 'package:flutter_health/components/datePicker.dart';
import 'package:flutter_health/components/dropDownButton.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/numberField.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:flutter_health/theme.dart';

class StepOne extends StatelessWidget {
  final void Function(int) setStep;
  final void Function(int) setUrgency;
  final int urgency;
  final TextEditingController patientName;
  final TextEditingController patientDoc;
  final TextEditingController patientAge;
  final TextEditingController patientMotherName;
  final String? patientGender;
  final void Function(String?) onGenderChanged;
  final TextEditingController susCard;
  final DateTime? patientBirthDate;
  final void Function(DateTime?) onBirthDateChanged;
  final String? jobStateType;

  const StepOne({
    required this.setStep,
    required this.setUrgency,
    required this.urgency,
    required this.patientName,
    required this.patientDoc,
    required this.patientAge,
    required this.patientMotherName,
    required this.patientGender,
    required this.onGenderChanged,
    required this.susCard,
    required this.patientBirthDate,
    required this.onBirthDateChanged,
    required this.jobStateType,
    Key? key,
  }) : super(key: key);

  String getUrgency() {
    String x = '';

    switch (urgency) {
      case 1:
        x = 'Alta';
        break;
      case 2:
        x = 'Moderada';
        break;
      case 3:
        x = 'Baixa';
        break;
      case 4:
        x = 'Miníma';
        break;
      default:
    }
    return x;
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              'Gravidade: ${getUrgency()}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => setUrgency(1),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: urgency == 1 ? redUrgency : whiteSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: redUrgency,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    child: Text(
                      'Alta',
                      style: TextStyle(
                        color: urgency == 1 ? whiteSecondary : redUrgency,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => setUrgency(2),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: urgency == 2 ? yellowUrgency : whiteSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: yellowUrgency,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    child: Text(
                      'Moderada',
                      style: TextStyle(
                        color: urgency == 2 ? whiteSecondary : yellowUrgency,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => setUrgency(3),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: urgency == 3 ? greenUrgency : whiteSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: greenUrgency,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    child: Text(
                      'Baixa',
                      style: TextStyle(
                        color: urgency == 3 ? whiteSecondary : greenUrgency,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => setUrgency(4),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: urgency == 4 ? blueUrgency : whiteSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: blueUrgency,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    child: Text(
                      'Miníma',
                      style: TextStyle(
                        color: urgency == 4 ? whiteSecondary : blueUrgency,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              'Dados do paciente',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(controller: patientName, label: 'Nome'),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: BuildNumberField(
                controller: patientDoc,
                label: 'Documento',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: DropdownField(
                options: ['Masculino', 'Feminino'],
                label: 'Genero',
                onChanged: onGenderChanged,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(
          controller: patientMotherName,
          label: 'Nome da Mãe',
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: BuildDatePicker(
                label: 'Data de Nascimento',
                selectedDate: patientBirthDate,
                onDateChanged: onBirthDateChanged,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: BuildNumberField(
                controller: patientAge,
                label: 'Idade',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildNumberField(
          controller: susCard,
          label: 'Cartão SUS/Convênio',
        ),
        const SizedBox(
          height: 50,
        ),
        MainButton(
          onPressed: () => setStep(2),
          text: 'Próximo',
          type: '1',
        ),
        if (jobStateType == 'Ambulância')
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              MainButton(
                onPressed: () => setStep(0),
                text: 'Voltar',
                type: '2',
              ),
            ],
          ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
