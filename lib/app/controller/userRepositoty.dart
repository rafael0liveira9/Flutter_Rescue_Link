import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'package:flutter_health/app/model/userModel.dart';
import 'package:flutter_health/database/db.dart';

class UserRepository {
  final DB _db = new DB();

  Future<UserModel?> createUser(UserModel user) async {
    try {
      final db = await _db.openDbUser();

      if (_db.database?.isOpen == true) {
        final users = await _db.database!.query(
          'user',
          where: 'email = ?',
          whereArgs: [user.email],
        );

        if (users.isNotEmpty) {
          final existingUser = UserModel.fromMap(users.first);

          existingUser.name = 'Usuário já cadatrado';
          return existingUser;
        }

        final now = DateTime.now().toIso8601String();
        user.createdAt = now;
        user.updatedAt = now;
        user.situation = 1;

        int id = await _db.database!.insert('user', user.toMap());
        user.id = id;

        return user;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> updateUser(int id, UserModel user) async {
    final db = await _db.openDbUser();

    if (_db.database?.isOpen == true) {
      user.updatedAt = DateTime.now().toIso8601String();

      await _db.database!.update(
        'user',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );

      return user;
    }
  }

  Future<bool> softDeleteUser(int id) async {
    final db = await _db.openDbUser();
    if (_db.database?.isOpen == true) {
      await _db.database!.update(
        'user',
        {'situation': 2},
        where: 'id = ?',
        whereArgs: [id],
      );

      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    final db = await _db.openDbUser();
    if (_db.database?.isOpen == true) {
      await _db.database!.delete(
        'user',
        where: 'id = ?',
        whereArgs: [id],
      );

      return true;
    } else {
      return false;
    }
  }

  Future<UserModel?> loginUser(UserModel loginUser) async {
    final db = await _db.openDbUser();

    if (_db.database?.isOpen == true) {
      final users = await _db.database!.query(
        'user',
        where: 'email = ? AND password = ? AND deletedAt IS NULL',
        whereArgs: [loginUser.email, loginUser.password],
      );

      if (users.isNotEmpty) {
        return UserModel.fromMap(users.first);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
