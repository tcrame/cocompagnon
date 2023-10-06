import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'belligerent.dart';
import 'monster.dart';

class SharedPreferencesUtils {
  static List<Monster> allMonsters = [];
  static Map<String, dynamic> allMonstersJson = {};

  static Future<dynamic> restoreMonster(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString("monster$id");
    if (string != null) {
      return json.decode(string.toString());
    } else {
      return null;
    }
  }

  static Future<void> saveMonster(int id, dynamic monsterJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("save monster id in shared prefs $id");
    await prefs.setString("monster$id", jsonEncode(monsterJson));
  }

  static Future<void> readFileAsync() {
    print('--- READ FILE ASYNC ---');
    return loadAsset().then((c) => importBestiary(c));
  }

  static void importBestiary(String json) {
    Map<String, dynamic> bestiary = jsonDecode(json);

    bestiary.forEach((k, v) => loadCreature(v, int.parse(k)));
  }

  static Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/json/bestiary.json');
  }

  static Future<void> saveBelligerent(Belligerent belligerent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(belligerent.uuid, jsonEncode(belligerent.toJson()));
  }

  static Future<void> loadCreature(dynamic storedCreature, int id) async {
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
            SharedPreferencesUtils.saveMonster(id, responseBody);
          }
        }
      } on DioException catch (e) {}
    } else {
      creatureJson = storedCreature;
    }
    if (creatureJson != null) {
      allMonsters.add(buildMonster(id, creatureJson));
      allMonstersJson[id.toString()] = creatureJson;
    } else {
      print("monster id $id is null");
    }
  }

  static Monster buildMonster(int id, dynamic creatureJson) {
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
    int strength = int.parse(getValueFromJson(creatureJson, "str_mod", "0")!);
    int dexterity = int.parse(getValueFromJson(creatureJson, "dex_mod", "0")!);
    int constitution = int.parse(getValueFromJson(creatureJson, "con_mod", "0")!);
    int intelligence = int.parse(getValueFromJson(creatureJson, "int_mod", "0")!);
    int wisdom = int.parse(getValueFromJson(creatureJson, "wis_mod", "0")!);
    int charisma = int.parse(getValueFromJson(creatureJson, "cha_mod", "0")!);

    Map<String, bool> supperiorAbilities = getSuperiorAbilities(creatureJson);

    return Monster(id, name, creatureTokenUrl, monsterType, monsterEnvironment, ncLevel, defense, initiative, healthPoint, monsterArchetype, monsterBossType, strength, dexterity, constitution,
        intelligence, wisdom, charisma, supperiorAbilities);
  }

  static Map<String, bool> getSuperiorAbilities(storedCreature) {
    List<dynamic> supAbilitiesJson = storedCreature['sup_abilities'];

    Map<String, bool> supAbilities = {};
    supAbilities["str"] = supAbilitiesJson.where((element) => element["value"] != null && element["value"] == "str").isNotEmpty;
    supAbilities["dex"] = supAbilitiesJson.where((element) => element["value"] != null && element["value"] == "dex").isNotEmpty;
    supAbilities["con"] = supAbilitiesJson.where((element) => element["value"] != null && element["value"] == "con").isNotEmpty;
    supAbilities["int"] = supAbilitiesJson.where((element) => element["value"] != null && element["value"] == "int").isNotEmpty;
    supAbilities["wis"] = supAbilitiesJson.where((element) => element["value"] != null && element["value"] == "wis").isNotEmpty;
    supAbilities["cha"] = supAbilitiesJson.where((element) => element["value"] != null && element["value"] == "cha").isNotEmpty;

    return supAbilities;
  }

  static String? getValueFromJson(dynamic creatureJson, String key, String? defaultValue) {
    List<dynamic> categories = creatureJson[key];
    dynamic firstCategory = categories.isNotEmpty ? categories[0] : null;
    return firstCategory != null ? firstCategory["value"] : defaultValue;
  }

  static Future<void> addInBelligerentIds(String newUuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList("belligerentIds");
    ids ??= [];
    ids.add(newUuid);
    await prefs.setStringList("belligerentIds", ids);
  }

  static Future<void> saveBelligerentIds(List<String> belligerentIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("belligerentIds", belligerentIds);
  }

  static Future<void> saveCurrentTurn(int turn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentTurn", turn);
  }

  static Future<int> restoreCurrentTurn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentTurn = prefs.getInt("currentTurn");
    return currentTurn ?? 1;
  }

  static Future<void> deleteBelligerent(String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(uuid);
  }

  static Future<Belligerent> restoreBelligerent(String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString(uuid);
    return Belligerent.fromJson(json.decode(string.toString()));
  }

  static Future<List<Belligerent>> restoreBelligerents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var ids = prefs.getStringList("belligerentIds");
    return  ids != null ? ids.map((id) => Belligerent.fromJson(json.decode(prefs.getString(id).toString()))).toList() : <Belligerent>[];
  }

  static Future<void> saveInitiativeOptionalRuleState(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("initiativeOptionalRuleState", state);
  }

  static Future<bool> restoreInitiativeOptionalRuleState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? state = prefs.getBool("initiativeOptionalRuleState");
    return state ?? true;
  }
}
