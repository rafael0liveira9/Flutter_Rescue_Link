class ServiceModel {
  int? id;
  int? userId;
  String? jobStateType;
  String? support;
  String? evolution;
  DateTime? startTime;
  DateTime? concludeTime;
  String statusService;
  String? serviceNumber;
  String? serviceCep;
  String? serviceStreet;
  String? serviceState;
  String? servicePlace;
  String? serviceCity;
  String? serviceDistrict;
  String? serviceStreetNumber;
  String? obsAmbulance;
  int? urgency;
  String? patientName;
  String? patientMotherName;
  String? patientDoc;
  String? susCard;
  String? patientAge;
  String? patientGender;
  DateTime? patientBirthDate;
  String reason;
  String? burn;
  String burnPercent;
  String? reasonComplement;
  String obstetrician;
  bool babyBorn;
  String? transportOrigin;
  String? transportService;
  String? transportResponsible;
  String transportCause;
  String? transportPlace;
  String? placeResponsible;
  String? mainComplaints;
  String? historic;
  String? hospitalizations;
  String? medicines;
  String? obsStep3;
  String airways;
  String breathing;
  String pulse;
  String perfusion;
  String skin;
  String edema;
  String eyeOpening;
  String verbalResponse;
  String motorResponse;
  String breathingResponse;
  String maxPA;
  String comaScale;

  ServiceModel({
    this.id,
    this.userId,
    this.jobStateType,
    this.support,
    this.evolution,
    this.startTime,
    this.concludeTime,
    this.statusService = '',
    this.serviceNumber,
    this.serviceCep,
    this.serviceStreet,
    this.serviceState,
    this.servicePlace,
    this.serviceCity,
    this.serviceDistrict,
    this.serviceStreetNumber,
    this.obsAmbulance,
    this.urgency = 4,
    this.patientName,
    this.patientMotherName,
    this.patientDoc,
    this.susCard,
    this.patientAge,
    this.patientGender,
    this.patientBirthDate,
    this.reason = '',
    this.burn = '',
    this.burnPercent = '',
    this.reasonComplement,
    this.obstetrician = '',
    this.babyBorn = false,
    this.transportOrigin,
    this.transportService,
    this.transportResponsible,
    this.transportCause = '',
    this.transportPlace,
    this.placeResponsible,
    this.mainComplaints,
    this.historic = '',
    this.hospitalizations,
    this.medicines,
    this.obsStep3,
    this.airways = '',
    this.breathing = '',
    this.pulse = '',
    this.perfusion = '',
    this.skin = '',
    this.edema = '',
    this.eyeOpening = '',
    this.verbalResponse = '',
    this.motorResponse = '',
    this.breathingResponse = '',
    this.maxPA = '',
    this.comaScale = '',
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      userId: map['userId'],
      jobStateType: map['jobStateType'],
      evolution: map['evolution'],
      support: map['support'],
      startTime: DateTime.tryParse(map['startTime'] ?? ''),
      concludeTime: DateTime.tryParse(map['concludeTime'] ?? ''),
      statusService: map['statusService'] ?? '',
      serviceNumber: map['serviceNumber'],
      serviceCep: map['serviceCep'],
      serviceStreet: map['serviceStreet'],
      serviceState: map['serviceState'],
      servicePlace: map['servicePlace'],
      serviceCity: map['serviceCity'],
      serviceDistrict: map['serviceDistrict'],
      serviceStreetNumber: map['serviceStreetNumber'],
      obsAmbulance: map['obsAmbulance'],
      urgency: map['urgency'] ?? 4,
      patientName: map['patientName'],
      patientMotherName: map['patientMotherName'],
      patientDoc: map['patientDoc'],
      susCard: map['susCard'],
      patientAge: map['patientAge'],
      patientGender: map['patientGender'],
      patientBirthDate: DateTime.tryParse(map['patientBirthDate'] ?? ''),
      reason: map['reason'] ?? '',
      burn: map['burn'],
      burnPercent: map['burnPercent'] ?? '',
      reasonComplement: map['reasonComplement'],
      obstetrician: map['obstetrician'] ?? '',
      babyBorn: map['babyBorn'] == 1,
      transportOrigin: map['transportOrigin'],
      transportService: map['transportService'],
      transportResponsible: map['transportResponsible'],
      transportCause: map['transportCause'] ?? '',
      transportPlace: map['transportPlace'],
      placeResponsible: map['placeResponsible'],
      mainComplaints: map['mainComplaints'],
      historic: map['historic'],
      hospitalizations: map['hospitalizations'],
      medicines: map['medicines'],
      obsStep3: map['obsStep3'],
      airways: map['airways'] ?? '',
      breathing: map['breathing'] ?? '',
      pulse: map['pulse'] ?? '',
      perfusion: map['perfusion'] ?? '',
      skin: map['skin'] ?? '',
      edema: map['edema'] ?? '',
      eyeOpening: map['eyeOpening'] ?? '',
      verbalResponse: map['verbalResponse'] ?? '',
      motorResponse: map['motorResponse'] ?? '',
      breathingResponse: map['breathingResponse'] ?? '',
      maxPA: map['maxPA'] ?? '',
      comaScale: map['comaScale'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'jobStateType': jobStateType,
      'evolution': evolution,
      'support': support,
      'startTime': startTime?.toIso8601String(),
      'concludeTime': concludeTime?.toIso8601String(),
      'statusService': statusService,
      'serviceNumber': serviceNumber,
      'serviceCep': serviceCep,
      'serviceStreet': serviceStreet,
      'serviceState': serviceState,
      'servicePlace': servicePlace,
      'serviceCity': serviceCity,
      'serviceDistrict': serviceDistrict,
      'serviceStreetNumber': serviceStreetNumber,
      'obsAmbulance': obsAmbulance,
      'urgency': urgency,
      'patientName': patientName,
      'patientMotherName': patientMotherName,
      'patientDoc': patientDoc,
      'susCard': susCard,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'patientBirthDate': patientBirthDate?.toIso8601String(),
      'reason': reason,
      'burn': burn,
      'burnPercent': burnPercent,
      'reasonComplement': reasonComplement,
      'obstetrician': obstetrician,
      'babyBorn': babyBorn ? 1 : 0,
      'transportOrigin': transportOrigin,
      'transportService': transportService,
      'transportResponsible': transportResponsible,
      'transportCause': transportCause,
      'transportPlace': transportPlace,
      'placeResponsible': placeResponsible,
      'mainComplaints': mainComplaints,
      'historic': historic,
      'hospitalizations': hospitalizations,
      'medicines': medicines,
      'obsStep3': obsStep3,
      'airways': airways,
      'breathing': breathing,
      'pulse': pulse,
      'perfusion': perfusion,
      'skin': skin,
      'edema': edema,
      'eyeOpening': eyeOpening,
      'verbalResponse': verbalResponse,
      'motorResponse': motorResponse,
      'breathingResponse': breathingResponse,
      'maxPA': maxPA,
      'comaScale': comaScale,
    };
  }

  @override
  String toString() {
    return 'ServiceModel{id: $id, userId: $userId, jobStateType: $jobStateType, support: $support, evolution: $evolution, startTime: $startTime, concludeTime: $concludeTime, statusService: $statusService, serviceNumber: $serviceNumber, serviceCep: $serviceCep, serviceStreet: $serviceStreet, serviceState: $serviceState, servicePlace: $servicePlace, serviceCity: $serviceCity, serviceDistrict: $serviceDistrict, serviceStreetNumber: $serviceStreetNumber, obsAmbulance: $obsAmbulance, urgency: $urgency, patientName: $patientName, patientMotherName: $patientMotherName, patientDoc: $patientDoc, susCard: $susCard, patientAge: $patientAge, patientGender: $patientGender, patientBirthDate: $patientBirthDate, reason: $reason, burn: $burn, burnPercent: $burnPercent, reasonComplement: $reasonComplement, obstetrician: $obstetrician, babyBorn: $babyBorn, transportOrigin: $transportOrigin, transportService: $transportService, transportResponsible: $transportResponsible, transportCause: $transportCause, transportPlace: $transportPlace, placeResponsible: $placeResponsible, mainComplaints: $mainComplaints, historic: $historic, hospitalizations: $hospitalizations, medicines: $medicines, obsStep3: $obsStep3, airways: $airways, breathing: $breathing, pulse: $pulse, perfusion: $perfusion, skin: $skin, edema: $edema, eyeOpening: $eyeOpening, verbalResponse: $verbalResponse, motorResponse: $motorResponse, breathingResponse: $breathingResponse, maxPA: $maxPA, comaScale: $comaScale}';
  }
}
