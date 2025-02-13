import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_helper.dart';
import 'planet.dart';

void main() {
  group('CRUD Operations Test', () {
    late DBHelper dbHelper;
    late Database db;

    setUp(() async {
      dbHelper = DBHelper();
      db = await dbHelper.database;
    });

    test('Insert Planet Test', () async {
      var planet = Planet(
        name: 'Terra',
        distanceFromSun: 1.0,
        size: 12742,
        nickname: 'Terra',
      );
      
      // Insere o planeta
      var id = await dbHelper.insertPlanet(planet);
      expect(id, greaterThan(0));

      // Verifica se foi inserido
      var planets = await dbHelper.getPlanets();
      expect(planets.length, greaterThan(0));
      expect(planets.first.name, equals('Terra'));
    });

    test('Update Planet Test', () async {
      var planet = Planet(
        name: 'Júpiter',
        distanceFromSun: 5.2,
        size: 139820,
        nickname: 'Gigante Gasoso',
      );
      
      var id = await dbHelper.insertPlanet(planet);

      var updatedPlanet = Planet(
        id: id,
        name: 'Júpiter',
        distanceFromSun: 5.2,
        size: 139820,
        nickname: 'O Maior Planeta',
      );

      // Atualiza o planeta
      var updateCount = await dbHelper.updatePlanet(updatedPlanet);
      expect(updateCount, greaterThan(0));

      // Verifica se o nome foi alterado
      var planets = await dbHelper.getPlanets();
      expect(planets.first.nickname, equals('O Maior Planeta'));
    });

    test('Delete Planet Test', () async {
      var planet = Planet(
        name: 'Marte',
        distanceFromSun: 1.5,
        size: 6779,
        nickname: 'Planeta Vermelho',
      );

      var id = await dbHelper.insertPlanet(planet);

      // Deleta o planeta
      var deleteCount = await dbHelper.deletePlanet(id);
      expect(deleteCount, greaterThan(0));

      // Verifica se o planeta foi excluído
      var planets = await dbHelper.getPlanets();
      expect(planets.any((element) => element.id == id), isFalse);
    });

    tearDown(() async {
      await db.close();
    });
  });
}
