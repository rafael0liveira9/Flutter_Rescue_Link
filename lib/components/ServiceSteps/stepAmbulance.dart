import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_health/components/dropDownButton.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/numberField.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:flutter_health/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class StepAmbulance extends StatefulWidget {
  final void Function(int) setStep;
  final TextEditingController serviceNumber;
  final TextEditingController serviceCep;
  final TextEditingController serviceStreet;
  final TextEditingController serviceCity;
  final TextEditingController serviceDistrict;
  final TextEditingController serviceStreetNumber;
  final void Function(String?) onStateChanged;
  final void Function(String?) setServicePlaceChanged;
  final TextEditingController obsAmbulance;
  String? serviceState;
  String? servicePlace;

  StepAmbulance({
    required this.serviceNumber,
    required this.setStep,
    required this.serviceCep,
    required this.serviceStreet,
    required this.serviceCity,
    required this.serviceDistrict,
    required this.serviceStreetNumber,
    required this.onStateChanged,
    required this.setServicePlaceChanged,
    required this.obsAmbulance,
    required this.serviceState,
    required this.servicePlace,
    Key? key,
  }) : super(key: key);

  @override
  _StepAmbulanceState createState() => _StepAmbulanceState();
}

class _StepAmbulanceState extends State<StepAmbulance> {
  bool cepError = false;
  bool streetError = false;
  bool streetNumberError = false;
  bool cityError = false;
  bool districtError = false;
  bool stateError = false;
  bool placeError = false;

  @override
  void initState() {
    super.initState();
    widget.serviceCep.addListener(_onCepChanged);
    widget.serviceCep.addListener(_cepCheck);
    widget.serviceStreet.addListener(_streetCheck);
  }

  @override
  void dispose() {
    widget.serviceCep.removeListener(_onCepChanged);
    super.dispose();
  }

  void _onCepChanged() {
    if (widget.serviceCep.text.length == 8) {
      fetchAddressFromCep(widget.serviceCep.text);
    }
  }

  void _nextStep() {
    if (widget.serviceNumber.text.isEmpty) {
      _showToast('Digite o número da ocorrência', false);
      setState(() {
        streetNumberError = true;
      });
      return null;
    }
    if (widget.serviceCep.text.length != 8) {
      _showToast('Digite um CEP Valido', false);
      setState(() {
        cepError = true;
      });
      return null;
    }
    if (widget.serviceState == null) {
      print(widget.serviceState);
      _showToast('Selecione o estado', false);
      setState(() {
        cepError = true;
      });
      return null;
    }
    if (widget.servicePlace == null) {
      print(widget.servicePlace);
      _showToast('Selecione o Local', false);
      setState(() {
        cepError = true;
      });
      return null;
    }

    if (widget.serviceStreetNumber.text.isEmpty) {
      _showToast('Digite um numero para o endereço', false);
      setState(() {
        streetNumberError = true;
      });
      return null;
    }
    if (widget.serviceStreet.text.isEmpty) {
      _showToast('Digite um endereço valido', false);
      setState(() {
        streetError = true;
      });
      return null;
    }
    if (widget.serviceDistrict.text.isEmpty) {
      _showToast('Digite um bairro valido', false);
      setState(() {
        districtError = true;
      });
      return null;
    }
    if (widget.serviceCity.text.isEmpty) {
      _showToast('Digite uma cidade valida', false);
      setState(() {
        cityError = true;
      });
      return null;
    }

    widget.setStep(1);
  }

  void _cepCheck() {
    if (widget.serviceCep.text.isNotEmpty) {
      if (widget.serviceCep.text.length != 8) {
        setState(() {
          cepError = true;
        });
      } else {
        cepError = false;
      }
    } else {
      cepError = false;
    }
  }

  void _streetCheck() {
    if (widget.serviceStreet.text.isNotEmpty) {
      if (widget.serviceStreet.text.length < 2) {
        setState(() {
          streetError = true;
        });
      } else {
        streetError = false;
      }
    } else {
      streetError = false;
    }
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

  String formatDocumentNumber(String number) {
    if (number.length == 11) {
      return '${number.substring(0, 3)}.${number.substring(3, 6)}.${number.substring(6, 9)}-${number.substring(9)}';
    } else {
      return number;
    }
  }

  final List<String> states = [
    "AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SP",
    "SE",
    "TO",
  ];

  final List<String> places = [
    "Via pública",
    "Domicílio",
    "Local de Trabalho",
    "Hospital",
    "UPA",
    "Unidade de Saúde",
    "Outro"
  ];

  Future<void> fetchAddressFromCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null && data['erro'] == null) {
        setState(() {
          widget.serviceStreet.text = data['logradouro'] ?? '';
          widget.serviceDistrict.text = data['bairro'] ?? '';
          widget.serviceCity.text = data['localidade'] ?? '';
          widget.onStateChanged(data['uf']);
        });
      }
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
              'Endereço da Ocorrência',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(
            controller: widget.serviceNumber, label: 'Número da Ocorrência'),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child:
                  BuildNumberField(controller: widget.serviceCep, label: 'CEP'),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BuildNumberField(
                  controller: widget.serviceStreetNumber,
                  label: 'Número na Rua'),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(controller: widget.serviceStreet, label: 'Nome da Rua'),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 58,
                child: DropdownField(
                    options: states,
                    label: 'Estado',
                    onChanged: widget.onStateChanged),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BuildTextField(
                  controller: widget.serviceCity, label: 'Cidade'),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                  controller: widget.serviceDistrict, label: 'Bairro'),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                height: 58,
                child: DropdownField(
                    options: places,
                    label: 'Local',
                    onChanged: widget.setServicePlaceChanged),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BuildTextField(controller: widget.obsAmbulance, label: 'Obs:'),
        const SizedBox(
          height: 40,
        ),
        MainButton(
          onPressed: _nextStep,
          text: 'Próximo',
          type: '1',
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
