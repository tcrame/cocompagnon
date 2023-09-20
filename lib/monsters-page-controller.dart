import 'dart:convert';

import 'package:cocompagnon/monster.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'monster-ids.dart';

class MonstersPageController extends ChangeNotifier {
  List<Monster> allMonsters = [];
  List<Monster> filteredMonsters = [];
  Set<MonsterType> monsterTypeFilters = {};
  Set<MonsterEnvironment> monsterEnvironmentFilters = {};
  String currentKeyWords = "";

  Future<void> loadAllCreatures() async {
    if (allMonsters.length != monsterIds.length) {
      allMonsters = [];
      for (var id in monsterIds) {
        restoreMonster(id).then((value) => loadCreature(value, id)).whenComplete(() => sortAllMonsterAndNotify());
      }
    } else {}
  }

  Future<void> loadCreature(dynamic storedCreature, int id) async {
    dynamic creatureJson;
    if (storedCreature == null) {
      try {
        final dio = Dio(BaseOptions(
          contentType: 'application/json',
        ));
        Response response = await dio.get("https://www.co-drs.org/fr/co/creature/$id/json");

        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = response.data;
          List<dynamic> names = responseBody["name"];
          String name = names[0]["value"];
          if (!name.contains("Cloned")) {
            creatureJson = responseBody;
            saveMonster(id, responseBody);
          }
        }
      } on DioException catch (e) {}
    } else {
      creatureJson = storedCreature;
    }
    allMonsters.add(buildMonster(id, creatureJson));
  }

  Future<void> saveMonster(int id, dynamic monsterJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("monster$id", jsonEncode(monsterJson));
  }

  Future<dynamic> restoreMonster(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString("monster$id");
    if (string != null) {
      return json.decode(string.toString());
    } else {
      return null;
    }
  }

  Monster buildMonster(int id, dynamic creatureJson) {
    List<dynamic> names = creatureJson["name"];
    String name = names[0]["value"];

    List<dynamic> pictures = creatureJson["picture"];
    dynamic firstPicture = pictures.isNotEmpty ? pictures[0] : null;
    String creatureTokenUrl = firstPicture != null
        ? firstPicture["creature_token_url"]
        : "https://www.co-drs.org/sites/default/files/styles/creatures_token/public/co/creature/2023-04/Sosie%20d%C3%A9moniaque.jpg.webp?itok=XNvMJvSR";

    MonsterType monsterType = MonsterType.fromName(getValueFromJson(creatureJson, "category", null));
    MonsterEnvironment monsterEnvironment = MonsterEnvironment.fromName(getValueFromJson(creatureJson, "environment", null));
    double ncLevel = double.parse(getValueFromJson(creatureJson, "level", "-1")!);
    int defense = int.parse(getValueFromJson(creatureJson, "defense", "-1")!);
    int initiative = int.parse(getValueFromJson(creatureJson, "init", "-1")!);
    int healthPoint = int.parse(getValueFromJson(creatureJson, "health_point", "-1")!);

    return Monster(id, name, creatureTokenUrl, monsterType, monsterEnvironment, ncLevel, defense, initiative, healthPoint);
  }

  String? getValueFromJson(dynamic creatureJson, String key, String? defaultValue) {
    List<dynamic> categories = creatureJson[key];
    dynamic firstCategory = categories.isNotEmpty ? categories[0] : null;
    return firstCategory != null ? firstCategory["value"] : defaultValue;
  }

  runFilter(String enteredKeyword) {
    currentKeyWords = enteredKeyword;
    applyFilters();
  }

  void applyFilters() {
    List<Monster> results = [];
    if (currentKeyWords.isEmpty) {
      results = allMonsters;
    } else {
      results = allMonsters.where((monster) => monster.name.toLowerCase().contains(currentKeyWords.toLowerCase())).toList();
    }

    if (monsterTypeFilters.isNotEmpty) {
      results = results.where((monster) => monsterTypeFilters.contains(monster.type)).toList();
    }

    if (monsterEnvironmentFilters.isNotEmpty) {
      results = results.where((monster) => monsterEnvironmentFilters.contains(monster.environment)).toList();
    }

    filteredMonsters = results;
    sortMonsterAndNotify();
  }

  sortAllMonsterAndNotify() {
    filteredMonsters = [];
    filteredMonsters.addAll(allMonsters);
    sortMonsterAndNotify();
  }

  sortMonsterAndNotify() {
    filteredMonsters.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void removeOrAddMonsterTypeFilterSelection(bool selected, MonsterType monsterType) {
    if (selected) {
      monsterTypeFilters.remove(monsterType);
    } else {
      monsterTypeFilters.add(monsterType);
    }
    applyFilters();
  }

  void removeOrAddMonsterEnvironmentFilterSelection(bool selected, MonsterEnvironment monsterEnvironment) {
    if (selected) {
      monsterEnvironmentFilters.remove(monsterEnvironment);
    } else {
      monsterEnvironmentFilters.add(monsterEnvironment);
    }
    applyFilters();
  }
}
