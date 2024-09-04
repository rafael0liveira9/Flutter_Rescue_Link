import 'package:flutter/material.dart';
import 'package:flutter_health/components/bollDropDown.dart';
import 'package:flutter_health/components/datePicker.dart';
import 'package:flutter_health/components/dropDownButton.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/numberField.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:flutter_health/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StepTwo extends StatelessWidget {
  final void Function(int) setStep;
  final String reason;
  final TextEditingController reasonComplement;
  final void Function(String) setReason;
  final List<String> burn;
  final void Function(String) setBurn;
  final String burnPercent;
  final void Function(String) setBurnPercent;
  final String obstetrician;
  final void Function(String) setObstetrician;
  final bool babyBorn;
  final void Function(bool) setBabyBorn;
  final TextEditingController transportOrigin;
  final TextEditingController transportService;
  final TextEditingController transportResponsible;
  final String transportCause;
  final void Function(String) setTransportCause;
  final TextEditingController transportPlace;
  final TextEditingController placeResponsible;
  final TextEditingController mainComplaints;

  const StepTwo({
    required this.setStep,
    required this.reason,
    required this.setReason,
    required this.burn,
    required this.setBurn,
    required this.burnPercent,
    required this.setBurnPercent,
    required this.reasonComplement,
    required this.obstetrician,
    required this.setObstetrician,
    required this.babyBorn,
    required this.setBabyBorn,
    required this.transportOrigin,
    required this.transportService,
    required this.transportResponsible,
    required this.transportCause,
    required this.setTransportCause,
    required this.transportPlace,
    required this.placeResponsible,
    required this.mainComplaints,
    Key? key,
  }) : super(key: key);

  void _nextStep() {
    if (reason.isEmpty) {
      _showToast('Selecione uma Natureza para o Atendimento', false);

      return null;
    }
    if (mainComplaints.text.isEmpty) {
      _showToast('Descreva os principais sintomas e queixas', false);

      return null;
    }

    if (reason == 'Transporte secundário' &&
        (transportOrigin.text.isEmpty || transportPlace.text.isEmpty)) {
      _showToast('Defina a origem e destino do transporte', false);
      return null;
    }

    setStep(4);
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
              'Natureza do Atendimento',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownField(
          options: const [
            'Acidente de Trânsito',
            'FAF',
            'FAB',
            'Trauma',
            'Agressão',
            'Desab/soterramento',
            'Eletrocussão',
            'Queimadura',
            'Clínico',
            'Psiquiátrico',
            'Pediátrico',
            'Gineco/Obstétrico',
            'Transporte secundário',
          ],
          label: 'Motivo',
          onChanged: (e) => setReason(e.toString()),
        ),
        if (reason == 'Queimadura')
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                child: const Text(
                  'Locais',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => setBurn('Vias aéreas'),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: burn.contains('Vias aéreas')
                              ? thirdColor
                              : Colors.white),
                      child: Text(
                        'Vias aéreas',
                        style: TextStyle(
                          color: burn.contains('Vias aéreas')
                              ? Colors.white
                              : fourthColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => setBurn('Térmica'),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: burn.contains('Térmica')
                              ? thirdColor
                              : Colors.white),
                      child: Text(
                        'Térmica',
                        style: TextStyle(
                          color: burn.contains('Térmica')
                              ? Colors.white
                              : fourthColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => setBurn('Química'),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: burn.contains('Química')
                              ? thirdColor
                              : Colors.white),
                      child: Text(
                        'Química',
                        style: TextStyle(
                          color: burn.contains('Química')
                              ? Colors.white
                              : fourthColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => setBurn('Elétrica'),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: burn.contains('Elétrica')
                              ? thirdColor
                              : Colors.white),
                      child: Text(
                        'Elétrica',
                        style: TextStyle(
                          color: burn.contains('Elétrica')
                              ? Colors.white
                              : fourthColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownField(
                options: const [
                  '10%',
                  '20%',
                  '30%',
                  '40%',
                  '50%',
                  '60%',
                  '70%',
                  '80%',
                  '90%',
                  '100%',
                ],
                label: 'Superficie %',
                onChanged: (e) => setBurnPercent(e.toString()),
              ),
            ],
          ),
        if (reason == 'Gineco/Obstétrico')
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              DropdownField(
                options: const [
                  'Trabalho de parto',
                  'Abortamento',
                  'Hemorragia vaginal',
                  'Dequitação de Placenta',
                ],
                label: 'Tipo',
                onChanged: (e) => setObstetrician(e.toString()),
              ),
              const SizedBox(
                height: 10,
              ),
              if (obstetrician == 'Trabalho de parto' ||
                  obstetrician == 'Abortamento')
                BoolDropdownField(
                    label: 'Recén nascido',
                    onChanged: (bool? e) => setBabyBorn(e!))
            ],
          ),
        if (reason == 'Transporte secundário')
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                controller: transportOrigin,
                label: 'Origem',
              ),
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                controller: transportService,
                label: 'Serviço médico',
              ),
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                controller: transportResponsible,
                label: 'Responsável',
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownField(
                options: const [
                  'Complexibilidade',
                  'Transferência',
                  'Apoio',
                  'Jurisdição',
                  'Outro',
                ],
                label: 'Motivo',
                onChanged: (e) => setTransportCause(e.toString()),
              ),
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                controller: transportPlace,
                label: 'Local de destino',
              ),
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                controller: placeResponsible,
                label: 'Responsável de destino',
              ),
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(
          controller: mainComplaints,
          label: 'Principais sintomas/queixas',
        ),
        const SizedBox(
          height: 20,
        ),
        BuildTextField(
          controller: reasonComplement,
          label: 'Obs:',
        ),
        const SizedBox(
          height: 50,
        ),
        MainButton(
          onPressed: () => _nextStep(),
          text: 'Próximo',
          type: '1',
        ),
        const SizedBox(
          height: 10,
        ),
        MainButton(
          onPressed: () => setStep(2),
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
