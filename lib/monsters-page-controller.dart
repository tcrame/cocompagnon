import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cocompagnon/monster.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'belligerent.dart';
import 'monster-ids.dart';

class MonstersPageController extends ChangeNotifier {
  List<Monster> allMonsters = [];

  //Map<String, dynamic> allMonstersJson = {};
  List<Monster> filteredMonsters = [];
  Set<MonsterType> monsterTypeFilters = {};
  Set<MonsterEnvironment> monsterEnvironmentFilters = {};
  Set<MonsterArchetype> monsterArchetypeFilters = {};
  Set<MonsterBossType> monsterBossTypeFilters = {};
  MonsterOrderBy currentOrderBy = MonsterOrderBy.alphabetic;
  TextEditingController orderByController = TextEditingController();
  TextEditingController bestiaireController = TextEditingController();
  String currentKeyWords = "";
  var uuidGenerator = const Uuid();

  Future<void> loadAllCreatures() async {
    if (allMonsters.length != monsterIds.length) {
      allMonsters = [];
      for (var id in monsterIds) {
        restoreMonster(id).then((value) => loadCreature(value, id)).whenComplete(() => sortAllMonsterAndNotify());
      }
    } else {}
  }

  Future<void> loadAllCreaturesLocally() async {
    if (allMonsters.length != monsterIds.length) {
      allMonsters = [];
      readFileAsync().whenComplete(() => sortAllMonsterAndNotify());
    }
  }

  Future<void> loadCreature(dynamic storedCreature, int id) async {
    dynamic creatureJson;
    if (storedCreature == null) {
      try {
        final dio = Dio(BaseOptions(contentType: 'application/json'));

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
    if (creatureJson != null) {
      allMonsters.add(buildMonster(id, creatureJson));
      //allMonstersJson[id.toString()] =  creatureJson;
    } else {
      print("monster id $id is null");
    }
  }

  Future<void> readFileAsync() {
    print('--- READ FILE ASYNC ---');
    return loadAsset().then((c) => importBestiary(c));
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/json/bestiary.json');
  }

  Future<void> saveMonster(int id, dynamic monsterJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("save monster id in shared prefs $id");
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
    MonsterArchetype monsterArchetype = MonsterArchetype.fromName(getValueFromJson(creatureJson, "archetype", null));
    MonsterBossType monsterBossType = MonsterBossType.fromName(getValueFromJson(creatureJson, "boss_type", null));
    double ncLevel = double.parse(getValueFromJson(creatureJson, "level", "-1")!);
    int defense = int.parse(getValueFromJson(creatureJson, "defense", "-1")!);
    int initiative = int.parse(getValueFromJson(creatureJson, "init", "-1")!);
    int healthPoint = int.parse(getValueFromJson(creatureJson, "health_point", "-1")!);

    return Monster(id, name, creatureTokenUrl, monsterType, monsterEnvironment, ncLevel, defense, initiative, healthPoint, monsterArchetype, monsterBossType);
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

    if (monsterArchetypeFilters.isNotEmpty) {
      results = results.where((monster) => monsterArchetypeFilters.contains(monster.archetype)).toList();
    }

    if (monsterBossTypeFilters.isNotEmpty) {
      results = results.where((monster) => monsterBossTypeFilters.contains(monster.bossType)).toList();
    }

    filteredMonsters = results;
    sortMonsterAndNotify();
  }

  sortAllMonsterAndNotify() {
    filteredMonsters = [];
    filteredMonsters.addAll(allMonsters);

    //saveAllJson();
    sortMonsterAndNotify();
  }

  //Future<void> saveAllJson() async {
  //  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //  await prefs.setString("allJson", jsonEncode(allMonstersJson));
  //}

  sortMonsterAndNotify() {
    switch (currentOrderBy) {
      case MonsterOrderBy.reverseAlphabetic:
        filteredMonsters.sort((a, b) => b.name.compareTo(a.name));
        break;
      case MonsterOrderBy.minNC:
        filteredMonsters.sort((a, b) => b.ncLevel.compareTo(a.ncLevel));
        break;
      case MonsterOrderBy.maxNc:
        filteredMonsters.sort((a, b) => a.ncLevel.compareTo(b.ncLevel));
        break;
      default:
        filteredMonsters.sort((a, b) => a.name.compareTo(b.name));
    }
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

  void removeOrAddMonsterArchetypeFilterSelection(bool selected, MonsterArchetype monsterEnvironment) {
    if (selected) {
      monsterArchetypeFilters.remove(monsterEnvironment);
    } else {
      monsterArchetypeFilters.add(monsterEnvironment);
    }
    applyFilters();
  }

  void removeOrAddMonsterBossTypeFilterSelection(bool selected, MonsterBossType monsterBossType) {
    if (selected) {
      monsterBossTypeFilters.remove(monsterBossType);
    } else {
      monsterBossTypeFilters.add(monsterBossType);
    }
    applyFilters();
  }

  void addMonsterInTracker(Monster monster) {
    addBelligerent(monster.name, monster.defense, monster.initiative, monster.healthPoint, monster.healthPoint, BelligerentType.enemy);
  }

  addBelligerent(String name, int defense, int initiative, int currentPv, int maxPv, BelligerentType? belligerentType) {
    int currentInit = initiative + Random().nextInt(6) + 1;
    String uuid = uuidGenerator.v1();
    var newBelligerent = Belligerent(
        name: name,
        defense: defense,
        initiative: initiative,
        currentPv: currentPv,
        maxPv: maxPv,
        belligerentType: belligerentType,
        currentInitiative: currentInit,
        uuid: uuid,
        debuffs: <BelligerentDebuff>[]);
    saveBelligerent(newBelligerent);
    addInBelligerentIds(uuid);
  }

  Future<void> saveBelligerent(Belligerent belligerent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(belligerent.uuid, jsonEncode(belligerent.toJson()));
  }

  Future<void> addInBelligerentIds(String newUuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList("belligerentIds");
    ids ??= [];
    ids.add(newUuid);
    await prefs.setStringList("belligerentIds", ids);
  }

  void changeSortingDirection(MonsterOrderBy orderBy) {
    currentOrderBy = orderBy;
    sortMonsterAndNotify();
  }

  void importBestiary(String json) {
    Map<String, dynamic> bestiary = jsonDecode(json);

    bestiary.forEach((k, v) => loadCreature(v, int.parse(k)));
  }
}
