import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_health/app/controller/servicesRepository.dart';
import 'package:flutter_health/app/model/serviceModel.dart';
import 'package:flutter_health/components/Modal/confirm.dart';
import 'package:flutter_health/components/Modal/register.dart';
import 'package:flutter_health/components/ServiceSteps/progressBar.dart';
import 'package:flutter_health/components/ServiceSteps/stepAmbulance.dart';
import 'package:flutter_health/components/ServiceSteps/stepFour.dart';
import 'package:flutter_health/components/ServiceSteps/stepOne.dart';
import 'package:flutter_health/components/ServiceSteps/stepThree.dart';
import 'package:flutter_health/components/ServiceSteps/stepTwo.dart';
import 'package:flutter_health/components/SideBar.dart';
import 'package:flutter_health/components/mainButton.dart';
import 'package:flutter_health/components/textFild.dart';
import 'package:flutter_health/theme.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final LocalStorage storage = LocalStorage('personal_data');
  var pageStep = 1;
  int userId = 0;
  String username = '';
  String jobStateType = '';
  bool jobStateIsOpen = false;
  final _stateController = TextEditingController();
  String stateName = '';

  // ServiceData
  DateTime? startTime;
  DateTime? concludeTime;
  String statusService = '';

  // step Ambulance var
  final serviceNumber = TextEditingController();
  final serviceCep = TextEditingController();
  final serviceStreet = TextEditingController();
  String? serviceState;
  String? servicePlace;
  final serviceCity = TextEditingController();
  final serviceDistrict = TextEditingController();
  final serviceStreetNumber = TextEditingController();
  final obsAmbulance = TextEditingController();

  // step 1 var
  var urgency = 3;
  final patientName = TextEditingController();
  final patientMotherName = TextEditingController();
  final patientDoc = TextEditingController();
  final susCard = TextEditingController();
  final patientAge = TextEditingController();
  String? patientGender;
  DateTime? patientBirthDate;

  // step 2 var
  String reason = '';
  List<String> burn = [];
  String burnPercent = '';
  final reasonComplement = TextEditingController();
  String obstetrician = '';
  bool babyBorn = false;
  final transportOrigin = TextEditingController();
  final transportService = TextEditingController();
  final transportResponsible = TextEditingController();
  String transportCause = '';
  final transportPlace = TextEditingController();
  final placeResponsible = TextEditingController();
  final mainComplaints = TextEditingController();

  // step 3 var
  List<String> historic = [];
  final hospitalizations = TextEditingController();
  final medicines = TextEditingController();
  final obsStep3 = TextEditingController();

  // step 4 var
  String airways = '';
  String breathing = '';
  String pulse = '';
  String perfusion = '';
  String skin = '';
  String edema = '';
  String eyeOpening = '';
  String verbalResponse = '';
  String motorResponse = '';
  String breathingResponse = '';
  String maxPA = '';
  String comaScale = '';

  get historicList => null;

  get babyBornSwitch => null;

  get burnList => null;

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

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      JobStateCheck(userData['jobStateType']);

      setState(() {
        userId = userData['id'];
        username = userData['name'] ?? '';
        jobStateType = userData['jobStateType'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  void dispose() {
    serviceNumber.dispose();
    serviceCep.dispose();
    serviceStreet.dispose();
    serviceCity.dispose();
    serviceDistrict.dispose();
    serviceStreetNumber.dispose();
    obsAmbulance.dispose();
    patientName.dispose();
    patientDoc.dispose();
    patientMotherName.dispose();
    patientAge.dispose();
    susCard.dispose();
    reasonComplement.dispose();
    transportOrigin.dispose();
    transportService.dispose();
    transportResponsible.dispose();
    transportPlace.dispose();
    placeResponsible.dispose();
    hospitalizations.dispose();
    medicines.dispose();
    obsStep3.dispose();
    mainComplaints.dispose();

    super.dispose();
  }

  void setStep(int step) {
    setState(() {
      pageStep = step;
    });
  }

  void JobStateCheck(String x) {
    if (x == 'Ambulância') {
      setState(() {
        pageStep = 0;
      });
    }
  }

  void setHistoric(String string) {
    setState(() {
      if (historic.contains(string)) {
        historic.remove(string);
      } else {
        historic.add(string);
      }
    });
  }

  void setUrgency(int int) {
    setState(() {
      urgency = int;
    });
  }

  void setPatientGender(String? gender) {
    setState(() {
      patientGender = gender;
    });
  }

  void setStateChanged(String? string) {
    setState(() {
      serviceState = string;
    });
  }

  void setServicePlaceChanged(String? string) {
    setState(() {
      servicePlace = string;
    });
  }

  void setReason(String string) {
    setState(() {
      reason = string;
    });
  }

  void setTransportCause(String string) {
    setState(() {
      transportCause = string;
    });
  }

  void setBabyBorn(bool live) {
    setState(() {
      babyBorn = live;
    });
  }

  void setObstetrician(String string) {
    setState(() {
      obstetrician = string;
    });
  }

  void setBurn(String string) {
    setState(() {
      if (burn.contains(string)) {
        burn.remove(string);
      } else {
        burn.add(string);
      }
    });
  }

  void setBurnPercent(String string) {
    setState(() {
      burnPercent = string;
    });
  }

  void setPatientBirthDate(DateTime? date) {
    setState(() {
      patientBirthDate = date;
    });
  }

  void _showConfirmationDialog(
      BuildContext context, Function() confirm, Function() close) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          confirm: confirm,
          close: close,
        );
      },
    );
  }

  void _showRegistrationDialog(
      BuildContext context, Function() confirm, Function() close) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegistrationDialog(
          confirm: confirm,
          close: close,
        );
      },
    );
  }

  void trueConfirmModal() {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  void setChangedStep4(String string, String param) {
    setState(() {
      switch (param) {
        case 'airways':
          airways = string;
          break;
        case 'breathing':
          breathing = string;
          break;
        case 'pulse':
          pulse = string;
          break;
        case 'perfusion':
          perfusion = string;
          break;
        case 'skin':
          skin = string;
          break;
        case 'edema':
          edema = string;
          break;
        case 'eyeOpening':
          eyeOpening = string;
          break;
        case 'verbalResponse':
          verbalResponse = string;
          break;
        case 'motorResponse':
          motorResponse = string;
          break;
        case 'breathingResponse':
          breathingResponse = string;
          break;
        case 'maxPA':
          maxPA = string;
          break;
        case 'comaScale':
          comaScale = string;
          break;
        default:
          break;
      }
    });
  }

  void closeConfirmModal() {}

  String _calculateAge() {
    DateTime now = DateTime.now();

    DateTime birthDate = DateTime.parse(patientBirthDate.toString());

    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age.toString();
  }

  void RegisterModal() {
    final service = ServiceModel(
      userId: userId,
      jobStateType: jobStateType,
      support: '',
      evolution: '',
      startTime: startTime,
      concludeTime: concludeTime,
      statusService: 'Em atendimento',
      serviceNumber: serviceNumber.text.isEmpty ? null : serviceNumber.text,
      serviceCep: serviceCep.text.isEmpty ? null : serviceCep.text,
      serviceStreet: serviceStreet.text.isEmpty ? null : serviceStreet.text,
      serviceState: serviceState ?? 'Não preenchido',
      servicePlace: servicePlace ?? 'Não preenchido',
      serviceCity: serviceCity.text.isEmpty ? null : serviceCity.text,
      serviceDistrict:
          serviceDistrict.text.isEmpty ? null : serviceDistrict.text,
      serviceStreetNumber:
          serviceStreetNumber.text.isEmpty ? null : serviceStreetNumber.text,
      obsAmbulance: obsAmbulance.text.isEmpty ? null : obsAmbulance.text,
      urgency: urgency,
      patientName:
          patientName.text.isEmpty ? 'Não identificado' : patientName.text,
      patientMotherName: patientMotherName.text.isEmpty
          ? 'Não identificado'
          : patientMotherName.text,
      patientDoc:
          patientDoc.text.isEmpty ? 'Não identificado' : patientDoc.text,
      susCard: susCard.text.isEmpty ? 'Não identificado' : susCard.text,
      patientAge: patientBirthDate != null
          ? _calculateAge()
          : patientAge.text.isEmpty
              ? 'Não identificado'
              : patientAge.text,
      patientGender: patientGender ?? 'Não identificado',
      patientBirthDate: patientBirthDate ?? null,
      reason: reason.isEmpty ? 'Não preenchido' : reason,
      burn: jsonEncode(burn),
      burnPercent: burnPercent.isEmpty ? '0%' : burnPercent,
      reasonComplement:
          reasonComplement.text.isEmpty ? null : reasonComplement.text,
      obstetrician: obstetrician.isEmpty ? 'Não' : obstetrician,
      babyBorn: babyBorn,
      transportOrigin:
          transportOrigin.text.isEmpty ? null : transportOrigin.text,
      transportService:
          transportService.text.isEmpty ? null : transportService.text,
      transportResponsible:
          transportResponsible.text.isEmpty ? null : transportResponsible.text,
      transportCause:
          transportCause.isEmpty ? 'Não preenchido' : transportCause,
      transportPlace: transportPlace.text.isEmpty ? null : transportPlace.text,
      placeResponsible:
          placeResponsible.text.isEmpty ? null : placeResponsible.text,
      mainComplaints: mainComplaints.text.isEmpty ? null : mainComplaints.text,
      historic: jsonEncode(historic),
      hospitalizations:
          hospitalizations.text.isEmpty ? 'Não' : hospitalizations.text,
      medicines: medicines.text.isEmpty ? 'Nenhum' : medicines.text,
      obsStep3: obsStep3.text.isEmpty ? null : obsStep3.text,
      airways: airways.isEmpty ? 'Não preenchido' : airways,
      breathing: breathing.isEmpty ? 'Não preenchido' : breathing,
      pulse: pulse.isEmpty ? 'Não preenchido' : pulse,
      perfusion: perfusion.isEmpty ? 'Não preenchido' : perfusion,
      skin: skin.isEmpty ? 'Não preenchido' : skin,
      edema: edema.isEmpty ? 'Não preenchido' : edema,
      eyeOpening: eyeOpening.isEmpty ? 'Não preenchido' : eyeOpening,
      verbalResponse:
          verbalResponse.isEmpty ? 'Não preenchido' : verbalResponse,
      motorResponse: motorResponse.isEmpty ? 'Não preenchido' : motorResponse,
      breathingResponse:
          breathingResponse.isEmpty ? 'Não preenchido' : breathingResponse,
      maxPA: maxPA.isEmpty ? 'Não preenchido' : maxPA,
      comaScale: comaScale.isEmpty ? 'Não preenchido' : comaScale,
    );

    final serviceRepository = ServiceRepository();

    serviceRepository.createService(service).then((createdService) {
      if (createdService != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.of(context).pushReplacementNamed('/');
        });
      } else {
        print('Failed to create service.');
      }
    }).catchError((error) {
      print('Error creating service: $error');
    });
  }

  void jobStateOpen() {
    setState(() {
      jobStateIsOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: primaryColor,
          drawer: Drawer(
            child: SideBar(jobStateOpen, true, Key('')),
          ),
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: thirdColor,
            ),
            centerTitle: true,
            elevation: 0,
            title: Image.asset(
              'assets/images/logo-2.png',
              height: 70,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(
                      color: thirdColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () => _showConfirmationDialog(
                            context,
                            trueConfirmModal,
                            closeConfirmModal,
                          ),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: thirdColor,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                          child: Row(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
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
                          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                          child: Row(
                            children: [
                              const Text(
                                'Registrar Atendimento',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: fourthColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProgressBar(
                                  progress: pageStep,
                                ),
                              )
                            ],
                          ),
                        ),
                        switch (pageStep) {
                          0 => StepAmbulance(
                              setStep: setStep,
                              serviceNumber: serviceNumber,
                              serviceCep: serviceCep,
                              serviceStreet: serviceStreet,
                              serviceCity: serviceCity,
                              serviceState: serviceState,
                              servicePlace: servicePlace,
                              serviceDistrict: serviceDistrict,
                              serviceStreetNumber: serviceStreetNumber,
                              onStateChanged: setStateChanged,
                              setServicePlaceChanged: setServicePlaceChanged,
                              obsAmbulance: obsAmbulance,
                            ),
                          1 => StepOne(
                              setStep: setStep,
                              setUrgency: setUrgency,
                              urgency: urgency,
                              patientName: patientName,
                              patientDoc: patientDoc,
                              patientMotherName: patientMotherName,
                              patientGender: patientGender,
                              onGenderChanged: setPatientGender,
                              patientAge: patientAge,
                              susCard: susCard,
                              patientBirthDate: patientBirthDate,
                              onBirthDateChanged: setPatientBirthDate,
                              jobStateType: jobStateType),
                          2 => StepThree(
                              setStep: setStep,
                              historic: historic,
                              setHistoric: setHistoric,
                              hospitalizations: hospitalizations,
                              medicines: medicines,
                              obs: obsStep3,
                            ),
                          3 => StepTwo(
                              setStep: setStep,
                              reason: reason,
                              setReason: setReason,
                              burn: burn,
                              setBurn: setBurn,
                              burnPercent: burnPercent,
                              setBurnPercent: setBurnPercent,
                              reasonComplement: reasonComplement,
                              obstetrician: obstetrician,
                              setObstetrician: setObstetrician,
                              babyBorn: babyBorn,
                              setBabyBorn: setBabyBorn,
                              transportOrigin: transportOrigin,
                              transportService: transportService,
                              transportResponsible: transportResponsible,
                              transportCause: transportCause,
                              setTransportCause: setTransportCause,
                              transportPlace: transportPlace,
                              placeResponsible: placeResponsible,
                              mainComplaints: mainComplaints,
                            ),
                          4 => StepFour(
                              setStep: setStep,
                              airways: airways,
                              breathing: breathing,
                              pulse: pulse,
                              perfusion: perfusion,
                              skin: skin,
                              edema: edema,
                              eyeOpening: eyeOpening,
                              verbalResponse: verbalResponse,
                              motorResponse: motorResponse,
                              breathingResponse: breathingResponse,
                              maxPA: maxPA,
                              comaScale: comaScale,
                              setChangedStep4: setChangedStep4,
                              register: () => _showRegistrationDialog(
                                    context,
                                    RegisterModal,
                                    closeConfirmModal,
                                  )),
                          _ => Container()
                        }
                      ],
                    ),
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
