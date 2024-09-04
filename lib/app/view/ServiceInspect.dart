import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health/app/controller/servicesRepository.dart';
import 'package:flutter_health/app/model/serviceModel.dart';
import 'package:flutter_health/components/Modal/conclude.dart';
import 'package:flutter_health/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pdfWidgets;

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  final serviceRepository = ServiceRepository();
  final id = Get.parameters['id'];
  String username = '';
  String email = '';
  String jobStateType = '';
  String stateName = '';

  late Future<ServiceModel?> service;

  Future<void> getUserData() async {
    print('getUserData');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      setState(() {
        username = userData['name'] ?? '';
        email = userData['email'] ?? '';
        jobStateType = userData['jobStateType'] ?? '';
        stateName = userData['stateName'] ?? '';
      });
    }
  }

  void _ConcludeService(BuildContext context, int? id) async {
    var serviceRepository = ServiceRepository();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConcludeDialog(
          confirm: () async {
            await serviceRepository.updateServiceStatus(id!).then(
                (value) => Navigator.of(context).pushReplacementNamed('/'));
          },
          close: () {},
        );
      },
    );
  }

  void FloatActionClick(ServiceModel service) {
    if (service.statusService == 'Em atendimento') {
      _ConcludeService(context, service.id);
    } else {
      generatePdf(service);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    service = serviceRepository.getServiceByServiceId(int.parse(id ?? '0'));
  }

  Future<void> generatePdf(ServiceModel service) async {
    final pdf = pw.Document();

    final downloadDirectory = Directory('/storage/emulated/0/Download');

    if (!(await downloadDirectory.exists())) {
      throw Exception('Diretório Download não encontrado');
    }

    final imageProvider = pdfWidgets.MemoryImage(
      (await rootBundle.load('assets/images/logo-2.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(imageProvider, width: 120, height: 60),
                  pw.Text(
                    '${service.serviceNumber != null ? 'Ocorrência ${service.serviceNumber}' : 'Atendimento ${service.id}'}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Container(
                width: double.infinity,
                height: 1,
                color: PdfColor.fromHex('#bababa'),
              ),
              pw.SizedBox(height: 15),
              if (username != '')
                pw.Text(
                    'Profissional: $username - ${service.jobStateType}: $stateName'),
              if (service.jobStateType != 'Ambulância')
                pw.Column(children: [
                  pw.Text(
                      'Local da Ocorrência: ${service.servicePlace} - Cep: ${service.serviceCep}'),
                  pw.Text(
                      '${service.serviceStreet}, ${service.serviceStreetNumber} - ${service.serviceDistrict}, ${service.serviceCity}-${service.serviceState}'),
                  if (service.obsAmbulance != null)
                    pw.Text(
                        'Observações sobre o Local: ${service.obsAmbulance}'),
                ]),
              if (service.startTime != null && service.concludeTime != null)
                pw.Text(
                    'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(service.startTime.toString()))} das ${DateFormat('hh:mm').format(DateTime.parse(service.startTime.toString()))} às ${DateFormat('hh:mm').format(DateTime.parse(service.concludeTime.toString()))}'),
              pw.Text(
                  'Natureza: ${service.reason} - Gravidade/Risco: ${_getUrgencyLabel(service.urgency.toString())}'),
              pw.SizedBox(height: 10),
              pw.Text(
                'Dados do paciente',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 3),
              pw.Text('${service.patientName}, ${service.patientAge} anos'),
              if (service.patientBirthDate != null)
                pw.Text(
                    'Nascido em: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(service.patientBirthDate.toString()))}'),
              pw.Text(
                  '${service.patientGender != null ? "Gênero: ${service.patientGender} - " : ''}Documento: ${service.patientDoc}'),
              pw.Text('Nome da mãe: ${service.patientMotherName}'),
              pw.SizedBox(height: 10),
              pw.Text(
                'Histórico do paciente',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 3),
              if (_getListStrings(service.historic) != '')
                pw.Text('Anteriores: ${_getListStrings(service.historic)}'),
              pw.Text('Hospitalizações: ${service.hospitalizations}'),
              pw.Text('Medicamentos: ${service.medicines}'),
              if (service.obsStep3 != null)
                pw.Text('Observações sobre Historico: ${service.obsStep3}'),
              pw.SizedBox(height: 10),
              pw.Text(
                'Mais informações - ${service.reason}',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 3),
              if (service.mainComplaints != null)
                pw.Text(
                    'Principais Sintomas/Queixas: ${service.mainComplaints}'),
              if (service.reason == 'Queimadura')
                pw.Column(children: [
                  if (_getListStrings(service.burn) != '')
                    pw.Text('Queimadura em: ${_getListStrings(service.burn)}'),
                  pw.Text('Queimadura em: ${service.burnPercent}'),
                ]),
              if (service.reason == 'Gineco/Obstétrico')
                pw.Column(children: [
                  pw.Text('Tipo: ${service.obstetrician}'),
                  if (service.obstetrician == 'Trabalho de parto' ||
                      service.obstetrician == 'Abortamento')
                    pw.Text(
                        'Recén nascido: ${service.babyBorn == true ? 'Sim' : 'Não'}')
                ]),
              if (service.reason == 'Transporte secundário')
                pw.Column(
                  children: [
                    pw.Text('Origem: ${service.transportOrigin}'),
                    pw.Text('Destino: ${service.transportPlace}'),
                    pw.Text('Serviço médico: ${service.transportService}'),
                    pw.Text('Responsável: ${service.transportResponsible}'),
                    pw.Text('Motivo: ${service.transportCause}'),
                    if (service.placeResponsible != null)
                      pw.Text(
                          'Responsável no destino: ${service.placeResponsible}'),
                  ],
                ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Respiratório',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                  'Vias aéreas: ${service.airways} - Ventilação: ${service.breathing}'),
              pw.SizedBox(height: 5),
              pw.Text(
                'Circulação',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                  'Pulso: ${service.pulse} - Perfusão: ${service.perfusion} - Pele: ${service.skin} - Edema: ${service.edema}'),
              pw.SizedBox(height: 5),
              pw.Text(
                'Escala de coma',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                  'Abertura dos olhos: ${service.eyeOpening} - Resposta Verbal: ${service.verbalResponse} - Resposta Motora: ${service.motorResponse}'),
              pw.SizedBox(height: 10),
              pw.Text(
                'Escala de trauma',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                  'P.A Máxima: ${service.maxPA} - Respiração: ${service.breathingResponse} - Escala coma: ${service.comaScale}'),
              if (service.reasonComplement != null)
                pw.Text(
                    'Observações sobre ${service.reason}: ${service.reasonComplement}'),
              pw.SizedBox(height: 50),
              pw.Padding(
                padding: pw.EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Center(
                        child: pw.Column(children: [
                          pw.Container(
                            width: 120,
                            height: 1,
                            color: PdfColor.fromHex('#bababa'),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            '$username',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ]),
                      ),
                      pw.Center(
                          child: pw.Column(children: [
                        pw.Container(
                          width: 120,
                          height: 1,
                          color: PdfColor.fromHex('#bababa'),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'Responsável',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                      ])),
                    ]),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  '*Atenção, todas as informações fornecidas são de exclusiva responsabilidade de ${username}, responsável ${service.serviceNumber != null ? 'pela Ocorrência ${service.serviceNumber}' : 'pelo atendimento ${service.id}'}.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.normal),
                ),
              ),
            ],
          );
        },
      ),
    );

    final file = File('${downloadDirectory.path}/ocorrencia_${service.id}.pdf');

    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF salvo em ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voltar'),
      ),
      floatingActionButton: FutureBuilder<ServiceModel?>(
        future: service,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final service = snapshot.data!;
            return FloatingActionButton(
              backgroundColor: thirdColor,
              onPressed: () => FloatActionClick(service),
              child: Icon(
                service.statusService == 'Em atendimento'
                    ? Icons.check
                    : Icons.download,
                color: whiteSecondary,
              ),
            );
          }
          return SizedBox();
        },
      ),
      body: FutureBuilder<ServiceModel?>(
        future: service,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar atendimento.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Atendimento não encontrado.'));
          } else {
            final service = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: _getSituationColor(service.statusService),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '${service.serviceNumber != null ? 'Ocorrência ${service.serviceNumber}' : 'Atendimento ${service.id}'} - ${service.statusService}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: whiteSecondary),
                    ),
                  ),
                  _buildSectionTitle('Resumo da Ocorrência', 2),
                  _buildInfoCard([
                    _buildInfoColoredRow(
                        'Gravidade:', service.urgency.toString()),
                    _buildInfoRow('Natureza:', service.reason),
                    if (username != '')
                      _buildInfoRow('Profissional:', username),
                    if (stateName != '')
                      _buildInfoRow('${service.jobStateType}:', stateName),
                    if (service.startTime != null)
                      _buildInfoRow('Data:',
                          '${DateFormat('dd/MM/-yyyy').format(DateTime.parse(service.startTime.toString()))}'),
                    if (service.startTime != null)
                      _buildInfoRow('Horário:',
                          '${service.concludeTime != null ? 'de ' : ''}${DateFormat('hh:mm').format(DateTime.parse(service.startTime.toString()))}${service.concludeTime != null ? ' à ${DateFormat('hh:mm').format(DateTime.parse(service.concludeTime.toString()))}' : ''}'),
                  ]),
                  service.jobStateType == 'Ambulância'
                      ? Column(
                          children: [
                            _buildSectionTitle('Endereço da Ocorrência', 1),
                            _buildInfoCard([
                              _buildInfoRow('Local:',
                                  service.servicePlace ?? 'Não preenchido'),
                              _buildInfoRow('CEP:',
                                  service.serviceCep ?? 'Não preenchido'),
                              _buildInfoRow('Rua:',
                                  service.serviceStreet ?? 'Não preenchido'),
                              _buildInfoRow('Número:',
                                  service.serviceNumber ?? 'Não preenchido'),
                              _buildInfoRow('Bairro:',
                                  service.serviceDistrict ?? 'Não preenchido'),
                              _buildInfoRow('Cidade:',
                                  service.serviceCity ?? 'Não preenchido'),
                              _buildInfoRow('Estado:',
                                  service.serviceState ?? 'Não preenchido'),
                              if (service.obsAmbulance != null)
                                _buildObsRow('Obs:',
                                    service.obsAmbulance ?? 'Não preenchido'),
                            ]),
                          ],
                        )
                      : Container(),
                  _buildSectionTitle('Informações do Paciente', 2),
                  _buildInfoCard([
                    if (service.susCard != null)
                      _buildInfoRow('Cartão SUS:', service.susCard),
                    _buildInfoRow('Nome:', service.patientName),
                    _buildInfoRow('Documento:', service.patientDoc),
                    _buildInfoRow('Gênero:', service.patientGender),
                    _buildInfoRow('Idade:', service.patientAge),
                    if (service.patientBirthDate != null)
                      _buildInfoRow('Data de Nascimento:',
                          '${DateFormat('dd-MM-yyyy').format(DateTime.parse(service.patientBirthDate.toString()))}'),
                    _buildInfoRow('Nome da Mãe:', service.patientMotherName),
                  ]),
                  _buildSectionTitle('Histórico do paciente', 1),
                  _buildInfoCard([
                    _buildListRow('Anteriores:', service.historic),
                    _buildInfoRow('Hospitalizações:', service.hospitalizations),
                    _buildInfoRow('Medicamentos:', service.medicines),
                    if (service.obsStep3 != null)
                      _buildObsRow(
                          'Obs:', service.obsStep3 ?? 'Não preenchido'),
                  ]),
                  _buildSectionTitle('Informações - ${service.reason}', 2),
                  _buildInfoCard([
                    _buildObsRow('Principais Sintomas/Queixas:',
                        service.mainComplaints ?? 'Não preenchido'),
                    if (service.reason == 'Queimadura')
                      Column(
                        children: [
                          _buildListRow('Queimadura em:', service.burn),
                          _buildInfoRow('Superficie %:', service.burnPercent),
                        ],
                      ),
                    if (service.reason == 'Gineco/Obstétrico')
                      Column(
                        children: [
                          _buildInfoRow('Tipo:', service.obstetrician),
                          if (service.obstetrician == 'Trabalho de parto' ||
                              service.obstetrician == 'Abortamento')
                            _buildInfoRow('Recén nascido:',
                                service.babyBorn == true ? 'Sim' : 'Não'),
                        ],
                      ),
                    if (service.reason == 'Transporte secundário')
                      Column(
                        children: [
                          _buildInfoRow('Origem:', service.transportOrigin),
                          _buildInfoRow('Destino:', service.transportPlace),
                          _buildInfoRow(
                              'Serviço médico:', service.transportService),
                          _buildInfoRow(
                              'Responsável:', service.transportResponsible),
                          _buildInfoRow('Motivo:', service.transportCause),
                          if (service.placeResponsible != null)
                            _buildInfoRow('Responsável no destino:',
                                service.placeResponsible),
                        ],
                      ),
                    _buildInfoRow('Vias aéreas:', service.airways),
                    _buildInfoRow('Ventilação:', service.breathing),
                    _buildInfoRow('Pulso:', service.pulse),
                    _buildInfoRow('Perfusão:', service.perfusion),
                    _buildInfoRow('Pele:', service.skin),
                    _buildInfoRow('Edema:', service.edema),
                    _buildInfoRow('Abertura dos olhos:', service.eyeOpening),
                    _buildInfoRow('Resposta Verbal:', service.verbalResponse),
                    _buildInfoRow('Resposta Motora:', service.motorResponse),
                    _buildInfoRow('Respiração:', service.breathingResponse),
                    _buildInfoRow('P.A Máxima:', service.maxPA),
                    _buildInfoRow('Escala coma:', service.comaScale),
                    if (service.reasonComplement != null)
                      _buildObsRow(
                          'Obs:', service.reasonComplement ?? 'Não preenchido'),
                  ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 70),
                    child: Text(
                      '*Atenção, todas as informações fornecidas são de exclusiva responsabilidade de ${username}, responsável ${service.serviceNumber != null ? 'pela Ocorrência ${service.serviceNumber}' : 'pelo atendimento ${service.id}'}.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, int side) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 40, 5, 5),
        child: side == 1
            ? Row(
                children: [
                  Text(
                    '${title}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: fourthColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: fourthColor,
                      thickness: 1,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: fourthColor,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${title}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: fourthColor,
                    ),
                  ),
                ],
              ));
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value ?? 'Não preenchido',
              style: const TextStyle(color: Colors.black54),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColoredRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 3),
              decoration: BoxDecoration(
                  color: _getUrgencyColor(value.toString()),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                _getUrgencyLabel(value.toString()) ?? 'Não preenchido',
                style: const TextStyle(color: whiteSecondary),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObsRow(String label, String? value) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value ?? 'Não preenchido',
              style: const TextStyle(color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListRow(String label, String? jsonString) {
  if (jsonString != null && jsonString.isNotEmpty) {
    List<String> values = List<String>.from(jsonDecode(jsonString));

    String formattedValue = values.join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              formattedValue.isNotEmpty ? formattedValue : 'Não preenchido',
              style: const TextStyle(color: Colors.black54),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container();
  }
}

String _getListStrings(String? jsonString) {
  if (jsonString != null && jsonString.isNotEmpty) {
    List<String> values = List<String>.from(jsonDecode(jsonString));

    String formattedValue = values.join(', ');

    return formattedValue;
  } else {
    return '';
  }
}

Color _getUrgencyColor(String urgency) {
  switch (urgency) {
    case '1':
      return redUrgency;
    case '2':
      return yellowUrgency;
    case '3':
      return blueUrgency;
    case '4':
      return greenUrgency;
    default:
      return Colors.grey;
  }
}

Color _getSituationColor(String situation) {
  switch (situation) {
    case 'Em atendimento':
      return oneSituation;
    case 'Concluído':
      return twoSituation;
    case 'Cancelado':
      return threSituation;

    default:
      return Colors.grey;
  }
}

String _getUrgencyLabel(String urgency) {
  switch (urgency) {
    case '1':
      return 'Alta';
    case '2':
      return 'Moderada';
    case '3':
      return 'Baixa';
    case '4':
      return 'Miníma';
    default:
      return 'Desconhecida';
  }
}
