import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  Database? database;

  Future<Database> openDbUser() async {
    if (database != null && database!.isOpen) {
      return database!;
    }

    database = await openDatabase(
      join(await getDatabasesPath(), 'rescue_link_v3.db'),
      version: 3,
      onCreate: (db, version) async {
        await db.execute(_user);
        await db.execute(_service);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(_user);
        }
        if (oldVersion < 3) {
          await db.execute(_service);
        }
      },
    );

    return database!;
  }

  String get _user => '''
  CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT,
    password TEXT,
    type INTEGER,
    situation INTEGER,
    jobStateType TEXT,
    createdAt TEXT,
    updatedAt TEXT,
    deletedAt TEXT
  );
  ''';

  String get _service => '''
  CREATE TABLE service (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER,
    jobStateType TEXT,
    startTime TEXT,
    concludeTime TEXT,
    support TEXT,
    evolution TEXT,
    statusService TEXT,
    serviceNumber TEXT,
    serviceCep TEXT,
    serviceStreet TEXT,
    serviceState TEXT,
    servicePlace TEXT,
    serviceCity TEXT,
    serviceDistrict TEXT,
    serviceStreetNumber TEXT,
    obsAmbulance TEXT,
    urgency INTEGER,
    patientName TEXT,
    patientMotherName TEXT,
    patientDoc TEXT,
    susCard TEXT,
    patientAge TEXT,
    patientGender TEXT,
    patientBirthDate TEXT,
    reason TEXT,
    burn TEXT,
    burnPercent TEXT,
    reasonComplement TEXT,
    obstetrician TEXT,
    babyBorn INTEGER,
    transportOrigin TEXT,
    transportService TEXT,
    transportResponsible TEXT,
    transportCause TEXT,
    transportPlace TEXT,
    placeResponsible TEXT,
    mainComplaints TEXT,
    historic TEXT,
    hospitalizations TEXT,
    medicines TEXT,
    obsStep3 TEXT,
    airways TEXT,
    breathing TEXT,
    pulse TEXT,
    perfusion TEXT,
    skin TEXT,
    edema TEXT,
    eyeOpening TEXT,
    verbalResponse TEXT,
    motorResponse TEXT,
    breathingResponse TEXT,
    maxPA TEXT,
    comaScale TEXT,
    FOREIGN KEY (userId) REFERENCES user(id) ON DELETE CASCADE
  );
  ''';
}
