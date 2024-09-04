import 'package:flutter/material.dart';
import 'package:flutter_health/app/controller/servicesRepository.dart';
import 'package:flutter_health/components/Modal/cancel.dart';
import 'package:flutter_health/components/Modal/conclude.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../theme.dart';

Widget HomeCard(BuildContext context, Map<String, dynamic> item,
        VoidCallback onUpdate) =>
    StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/service/${item['id']}');
          },
          onLongPress: item['statusService'] == 'Cancelado'
              ? () {}
              : () {
                  _CancelService(context, item['id'], () {
                    setState(
                      () {
                        item['statusService'] = 'Cancelado';
                      },
                    );
                  });
                },
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            _getUrgencyIcon(item['urgency'].toString()),
                            color: _getUrgencyColor(item['urgency'].toString()),
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Paciente: ${item['patientName'] == null || item['patientName'] == 'Não identificado' ? 'Não Identificado' : getFirstName(item['patientName'].toString())}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (item['patientAge'] != null &&
                                      item['patientAge'] != 'Não identificado')
                                    Text(
                                      ', ${item['patientAge']} anos',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (item['startTime'] != null)
                                Row(
                                  children: [
                                    Text(
                                      '${item['concludeTime'] != null ? 'Início: ' : 'Início às '} ${DateFormat('hh:mm').format(DateTime.parse(item['startTime']))}',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    if (item['concludeTime'] != null)
                                      Text(
                                        'Encerramento: ${DateFormat('hh:mm').format(DateTime.parse(item['concludeTime']))}',
                                      ),
                                  ],
                                ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Status: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: _getSituationColor(
                                            item['statusService'].toString())),
                                    child: Text(
                                      ' ${item['statusService'].toString()}',
                                      style: const TextStyle(
                                          color: fourthColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        item['concludeTime'] == null
                            ? InkWell(
                                onTap: () =>
                                    _ConcludeService(context, item['id'], () {
                                  setState(
                                    () {
                                      item['statusService'] = 'Concluído';
                                      item['concludeTime'] =
                                          DateTime.now().toString();
                                    },
                                  );
                                }),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: greyLight,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: greyLight,
                                    size: 33,
                                  ),
                                ),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: item['statusService'] == 'Cancelado'
                                      ? threSituation
                                      : greenUrgency,
                                  border: Border.all(
                                    color: whiteSecondary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                child: Icon(
                                  item['statusService'] == 'Cancelado'
                                      ? Icons.close
                                      : Icons.check,
                                  color: fourthColor,
                                  size: 33,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -18,
                    left: -5,
                    child: Row(
                      children: [
                        if (item['startTime'] != null)
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: item['concludeTime'] == null
                                  ? oneSituation
                                  : item['statusService'] == 'Cancelado'
                                      ? threSituation
                                      : thirdColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              border: Border.all(
                                color: Color.fromARGB(86, 158, 158, 158),
                              ),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(item['startTime'])),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: item['concludeTime'] == null
                                    ? fourthColor
                                    : item['statusService'] == 'Cancelado'
                                        ? fourthColor
                                        : whiteSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (item['reason'] != null &&
                            item['reason'] != 'Não preenchido')
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: thirdColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              border: Border.all(
                                color: Color.fromARGB(86, 158, 158, 158),
                              ),
                            ),
                            child: Text(
                              item['reason'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: whiteSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

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

IconData _getUrgencyIcon(String urgency) {
  switch (urgency) {
    case '1':
      return Icons.sentiment_dissatisfied;
    case '2':
      return Icons.sentiment_satisfied;
    case '3':
      return Icons.sentiment_satisfied_alt;
    case '4':
      return Icons.sentiment_very_satisfied;
    default:
      return Icons.medical_services;
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

String getFirstName(String fullName) {
  List<String> nameParts = fullName.split(' ');

  return nameParts.isNotEmpty ? nameParts[0] : '';
}

void _ConcludeService(
    BuildContext context, int id, VoidCallback onUpdate) async {
  var serviceRepository = ServiceRepository();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConcludeDialog(
        confirm: () async {
          await serviceRepository
              .updateServiceStatus(id)
              .then((value) => onUpdate);
        },
        close: () {},
      );
    },
  ).then((value) => onUpdate());
}

void _CancelService(BuildContext context, int id, VoidCallback onUpdate) async {
  var serviceRepository = ServiceRepository();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CancelDialog(
        confirm: () async {
          await serviceRepository
              .cancelServiceStatus(id)
              .then((value) => onUpdate);
        },
        close: () {},
      );
    },
  ).then((value) => onUpdate());
}
