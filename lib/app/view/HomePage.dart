import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_health/app/controller/servicesRepository.dart';
import 'package:flutter_health/components/Modal/conclude.dart';
import 'package:flutter_health/components/dropDownButton.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_health/components/SideBar.dart';
import 'package:flutter_health/theme.dart';
import '../../components/HomeCard.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _register = [];
  final _stateController = TextEditingController();
  int userId = 0;
  String username = '';
  String email = '';
  String jobStateType = '';
  String stateName = '';
  bool isLoading = false;
  bool jobStateIsOpen = false;
  String filterType = 'Em atendimento';
  final filterOptions = [
    'Em atendimento',
    'Cancelado',
    'Concluído',
    'Por Gravidade',
  ];

  Future<void> getUserData() async {
    print('getUserData');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      var serviceRepository = ServiceRepository();
      var servicesTemp =
          await serviceRepository.getServicesByUserId(userData['id']);
      setState(() {
        userId = userData['id'];
        username = userData['name'] ?? '';
        email = userData['email'] ?? '';
        jobStateType = userData['jobStateType'] ?? '';
        stateName = userData['stateName'] ?? '';

        _register = (servicesTemp.map((service) => service.toMap()).toList());
      });

      _register.sort(
        (a, b) {
          DateTime dateA = DateTime.parse(a['startTime']);
          DateTime dateB = DateTime.parse(b['startTime']);

          return dateB.compareTo(dateA);
        },
      );

      filter(filterType);

      if (stateName.isEmpty) {
        setState(() {
          jobStateIsOpen = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();
    filter(filterType);

    setState(() {});
  }

  void jobStateOpen() {
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaa');
    setState(() {
      jobStateIsOpen = true;
    });
  }

  void filter(String x) {
    switch (x) {
      case 'Em atendimento':
        print('1f');
        _register.sort((a, b) {
          List<String> situationOrder = [
            'Em atendimento',
            'Concluído',
            'Cancelado',
          ];

          int situationA = situationOrder.indexOf(a['statusService'] ?? '');
          int situationB = situationOrder.indexOf(b['statusService'] ?? '');

          print(situationA + situationB);

          if (situationA != situationB) {
            return situationA.compareTo(situationB);
          }

          DateTime dateA = DateTime.parse(a['startTime']);
          DateTime dateB = DateTime.parse(b['startTime']);
          return dateB.compareTo(dateA);
        });

        break;
      case 'Cancelado':
        print('2f');
        _register.sort((a, b) {
          List<String> situationOrder = [
            'Cancelado',
            'Em atendimento',
            'Concluído',
          ];

          int situationA = situationOrder.indexOf(a['statusService'] ?? '');
          int situationB = situationOrder.indexOf(b['statusService'] ?? '');

          if (situationA != situationB) {
            return situationA.compareTo(situationB);
          }

          DateTime dateA = DateTime.parse(a['startTime']);
          DateTime dateB = DateTime.parse(b['startTime']);
          return dateB.compareTo(dateA);
        });

        break;
      case 'Concluído':
        print('3f');
        _register.sort((a, b) {
          List<String> situationOrder = [
            'Concluído',
            'Em atendimento',
            'Cancelado',
          ];

          int situationA = situationOrder.indexOf(a['statusService'] ?? '');
          int situationB = situationOrder.indexOf(b['statusService'] ?? '');

          if (situationA != situationB) {
            return situationA.compareTo(situationB);
          }

          DateTime dateA = DateTime.parse(a['startTime']);
          DateTime dateB = DateTime.parse(b['startTime']);
          return dateB.compareTo(dateA);
        });

        break;
      case 'Por Gravidade':
        print('4f');
        _register.sort((a, b) {
          List<int> situationOrder = [1, 2, 3, 4];

          int situationA = situationOrder.indexOf(a['urgency']);
          int situationB = situationOrder.indexOf(b['urgency']);

          if (situationA != situationB) {
            return situationA.compareTo(situationB);
          }

          DateTime dateA = DateTime.parse(a['startTime']);
          DateTime dateB = DateTime.parse(b['startTime']);
          return dateB.compareTo(dateA);
        });

        break;
      default:
    }
  }

  bool sheduleCheck() {
    bool hasInAttendance = _register
        .any((service) => service['statusService'] == 'Em atendimento');

    return hasInAttendance;
  }

  void onJobSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      userData['stateName'] = _stateController.text;

      prefs.setString('userData', jsonEncode(userData));

      setState(() {
        stateName = userData['stateName'];
        jobStateIsOpen = false;
      });
    }
  }

  void onFloatClick() async {
    if (stateName.isEmpty) {
      setState(() {
        jobStateIsOpen = true;
      });
    } else {
      Navigator.of(context).pushNamed('/service');
    }
  }

  @override
  void dispose() {
    _stateController.dispose();

    super.dispose();

    getUserData();
    filter(filterType);
  }

  concludeService() async {
    print('getData');

    await getUserData().then((value) => filter(filterType));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: primaryColor,
          drawer: Drawer(
            child: SideBar(jobStateOpen, false, Key('')),
          ),
          appBar: AppBar(
            backgroundColor: primaryColor,
            toolbarHeight: 80,
            iconTheme: const IconThemeData(
              color: thirdColor,
            ),
            centerTitle: true,
            elevation: 0,
            title: Image.asset(
              'assets/images/logo-2.png',
              height: 90,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: thirdColor,
            onPressed: () => sheduleCheck() == true
                ? _showToast('Conclua o atendimento atual primeiro...', false)
                : onFloatClick(),
            child: const Icon(Icons.add, color: whiteSecondary),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
                child: SizedBox(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Divider(
                        color: fourthColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Olá, ',
                                style: TextStyle(
                                  color: fourthColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                '${username}',
                                style: TextStyle(
                                  color: fourthColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                          decoration: const BoxDecoration(
                            color: whiteSecondary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Historico de Atendimentos',
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
                                    ),
                                    if (_register.length > 1)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 80,
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              height: 56,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: DropdownButtonFormField<
                                                  String>(
                                                value: filterType,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  labelText: 'Mostrar Primeiro',
                                                  labelStyle: TextStyle(
                                                    color: fourthColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                                ),
                                                items: filterOptions
                                                    .map((String option) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: option,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      option,
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  filter(newValue ??
                                                      'Em atendimento');
                                                  setState(() {
                                                    filterType = newValue ??
                                                        'Em atendimento';
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Em atendimento';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              _register.isNotEmpty
                                  ? Expanded(
                                      child: ListView.builder(
                                        itemCount: _register.length,
                                        itemBuilder: (context, index) {
                                          final item = _register[index];
                                          return Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              HomeCard(
                                                context,
                                                item,
                                                () => concludeService(),
                                              ),
                                              index == _register.length - 1
                                                  ? const SizedBox(height: 80)
                                                  : const SizedBox(height: 8)
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      height: 100,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Nenhum atendimento registrado...'),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (jobStateIsOpen)
          Material(
            color: const Color.fromARGB(100, 0, 0, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => setState(() {
                            jobStateIsOpen = false;
                          }),
                          child: Icon(
                            Icons.close,
                            size: 35,
                          ),
                        ),
                      ),
                      if (jobStateType == 'Ambulância')
                        Text(
                          'Identificação da sua Ambulância.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Text(
                          'Nome da Unidade de Trabalho.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(25),
                        child: BuildTextField(
                            controller: _stateController,
                            label: jobStateType == 'Ambulância'
                                ? 'Código'
                                : 'Nome'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MainButton(
                          onPressed: () => onJobSave(),
                          text: 'SALVAR',
                          type: '1')
                    ],
                  ),
                ),
              ),
            ),
          )
      ],
    );
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
