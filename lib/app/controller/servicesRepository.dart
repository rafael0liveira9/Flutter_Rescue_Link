import 'package:flutter_health/app/model/serviceModel.dart';
import 'package:flutter_health/database/db.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class ServiceRepository {
  final DB _db = new DB();

  Future<ServiceModel?> createService(ServiceModel service) async {
    try {
      final db = await _db.openDbUser();

      if (_db.database?.isOpen == true) {
        service.statusService = service.statusService ?? 'Em atendimento';
        service.startTime = DateTime.now();

        int id = await _db.database!.insert('service', service.toMap());
        service.id = id;

        print('Service Created: ${service}');
        return service;
      }
    } catch (e) {
      print('Error creating service: $e');
      return null;
    }
  }

  Future<List<ServiceModel>> getServicesByUserId(int userId) async {
    Database? db;

    try {
      db = await _db.openDbUser();

      if (db == null || !db.isOpen) {
        throw Exception("Database connection is not open.");
      }

      final List<Map<String, dynamic>> x = await db.query(
        'service',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      var list = x.map((e) {
        return ServiceModel.fromMap(Map<String, dynamic>.from(e));
      }).toList();

      print(list);

      return list;
    } catch (error) {
      print('Error fetching services: $error');
      return [];
    }
  }

  Future<ServiceModel?> getServiceByServiceId(int serviceId) async {
    Database? db;

    try {
      db = await _db.openDbUser();

      if (db == null || !db.isOpen) {
        throw Exception("Database connection is not open.");
      }

      final List<Map<String, dynamic>> result = await db.query(
        'service',
        where: 'id = ?',
        whereArgs: [serviceId],
      );

      if (result.isNotEmpty) {
        return ServiceModel.fromMap(Map<String, dynamic>.from(result.first));
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching service: $error');
      return null;
    }
  }

  Future<void> updateServiceStatus(int serviceId) async {
    Database? db;

    try {
      db = await _db.openDbUser();

      if (db == null || !db.isOpen) {
        throw Exception("Database connection is not open.");
      }

      Map<String, dynamic> updates = {
        'statusService': 'Concluído',
        'concludeTime': DateTime.now().toIso8601String(),
      };

      await db.update(
        'service',
        updates,
        where: 'id = ?',
        whereArgs: [serviceId],
      );

      print('Service updated: id=$serviceId, status=Concluído');
    } catch (error) {
      print('Error updating service: $error');
    }
  }

  Future<void> cancelServiceStatus(int serviceId) async {
    Database? db;

    try {
      db = await _db.openDbUser();

      if (db == null || !db.isOpen) {
        throw Exception("Database connection is not open.");
      }

      Map<String, dynamic> updates = {
        'statusService': 'Cancelado',
        'concludeTime': DateTime.now().toIso8601String(),
      };

      await db.update(
        'service',
        updates,
        where: 'id = ?',
        whereArgs: [serviceId],
      );

      print('Service updated: id=$serviceId, status=Concluído');
    } catch (error) {
      print('Error updating service: $error');
    }
  }
}
