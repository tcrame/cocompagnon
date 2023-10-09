import 'dart:convert';

import 'package:cocompagnon/models/monster-details.dart';
import 'package:cocompagnon/utils/shared-preferences-utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/monster.dart';

class MonstersPageDetailsController extends ChangeNotifier {
  MonsterDetails? monsterDetails;

  Future<void> loadMonsterDetails(int id) async {
    loadCreature(SharedPreferencesUtils.allMonstersJson[id.toString()]).whenComplete(() => notifyListeners());
  }

  Future<dynamic> restoreMonster(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString("monster$id");
    if (string != null) {
      return json.decode(string.toString());
    } else {
      print("creature id $id is null");
      return null;
    }
  }

  Future<void> loadCreature(dynamic storedCreature) async {
    if (storedCreature != null && storedCreature != "") {
      String description = getValueFromJsonWithArray(storedCreature, "description", "value", "");
      String appearance = getValueFromJsonWithArray(storedCreature, "appearance", "value", "");
      String comments = getValueFromJsonWithArray(storedCreature, "comments", "value", "");
      String monsterFamillyLabel = getValueFromJsonWithArray(storedCreature, "creature_family", "label", "");
      int monsterFamillyId = int.parse(getValueFromJsonWithArray(storedCreature, "creature_family", "target_id", "0"));
      List<dynamic> pictures = storedCreature["picture"];
      dynamic firstPicture = pictures.isNotEmpty ? pictures[0] : null;
      String creatureTokenUrl = firstPicture != null
          ? firstPicture["creature_token_url"]
          : "https://www.co-drs.org/sites/default/files/styles/creatures_token/public/co/creature/2023-04/Sosie%20d%C3%A9moniaque.jpg.webp?itok=XNvMJvSR";
      String size = getValueFromJsonWithSubKey(storedCreature, "size", "label", "");
      String category = getValueFromJsonWithSubKey(storedCreature, "category", "label", "");
      String environment = getValueFromJsonWithSubKey(storedCreature, "environment", "label", "");
      String archetype = getValueFromJsonWithSubKey(storedCreature, "archetype", "label", "");
      int bossRank = int.parse(getValueFromJsonWithArray(storedCreature, "boss_rank", "value", "0").replaceAll(".5", ""));

      List<MonsterAttack?> attacks = getAttacks(storedCreature);
      List<String?> paths = getPaths(storedCreature);
      List<MonsterCapability?> capabilities = getCapabilities(storedCreature);
      List<String?> specialCapabilities = getSpecialCapabilities(storedCreature);
      MonsterProfile? monsterProfile = getMonsterProfile(storedCreature);

      monsterDetails = MonsterDetails(description, appearance, comments, size, creatureTokenUrl.replaceAll("/creatures_token/", "/original_compressed/"), category, environment, archetype, bossRank,
          MonsterFamilly(monsterFamillyLabel, monsterFamillyId), attacks, paths, capabilities, specialCapabilities, monsterProfile);
    } else {
      print("stored creature is null");
    }
  }

  String printCaracMod(int mod) {
    if (mod > 0) {
      return '+$mod';
    } else {
      return '$mod';
    }
  }

  String getValueFromJson(dynamic creatureJson, String key, String defaultValue) {
    List<dynamic> categories = creatureJson[key];
    dynamic firstCategory = categories.isNotEmpty ? categories[0] : null;
    return firstCategory != null && firstCategory["value"] != null ? firstCategory["value"] : defaultValue;
  }

  String getValueFromJsonWithArray(dynamic creatureJson, String key, String subKey, String defaultValue) {
    List<dynamic> values = creatureJson[key];
    dynamic firstRow = values.isNotEmpty ? values[0] : null;
    return firstRow != null && firstRow[subKey] != null ? firstRow[subKey] : defaultValue;
  }

  String getValueFromJsonWithSubKey(dynamic creatureJson, String key, String subKey, String defaultValue) {
    List<dynamic> categories = creatureJson[key];
    dynamic firstCategory = categories.isNotEmpty ? categories[0] : null;
    return firstCategory != null && firstCategory[subKey] != null ? firstCategory[subKey] : defaultValue;
  }

  List<MonsterAttack?> getAttacks(creatureJson) {
    List<dynamic> attacksJson = creatureJson['attacks'];
    return attacksJson.map((attackJson) => mapMonsterAttack(attackJson)).toList();
  }

  MonsterAttack? mapMonsterAttack(attackJson) {
    String? label = attackJson["value"];
    List<dynamic> dataList = attackJson["data"];
    dynamic firstData = dataList.isNotEmpty ? dataList[0] : null;
    if(firstData != null) {
      String? name = firstData["name"];
      String? test = firstData["test"];
      String? dm = firstData["dm"];
      String? special = firstData["special"];
      String? reach = firstData["reach"];
      return MonsterAttack(label, name, test, dm, special, reach);
    } else {
      return null;
    }
  }

  List<String?> getPaths(creatureJson) {
    List<dynamic> pathsJson = creatureJson['paths'];
    return pathsJson.map((pathJson) => mapValue(pathJson)).toList();
  }

  String? mapValue(pathJson) {
    return pathJson["value"];
  }

  List<MonsterCapability?> getCapabilities(dynamic creatureJson) {
    List<dynamic> capabilities = creatureJson['capabilities'];
    return capabilities.map((capability) => mapMonsterCapability(capability)).toList();
  }

  MonsterCapability mapMonsterCapability(dynamic capabilityJson) {
    String? label = capabilityJson["label"];
    int? rank = capabilityJson["rank"] != null ? int.parse(capabilityJson["rank"]) : 0;
    bool? isLimited = capabilityJson["is_limited"] != null ? int.parse(capabilityJson["is_limited"]) == 1 : false;
    bool? isMagical = capabilityJson["is_magical"] != null ? int.parse(capabilityJson["is_magical"]) == 1 : false;
    String? description = capabilityJson["description"];
    String? paths = capabilityJson["paths"];
    return MonsterCapability(label, rank, isLimited, isMagical, description, paths, false);
  }

  bool hasPath() {
    return monsterDetails != null && monsterDetails!.paths.where((element) => element != null).isNotEmpty;
  }

  bool hasSpecialCapabalities() {
    return monsterDetails != null && monsterDetails!.specialCapabilities.where((element) => element != null).isNotEmpty;
  }

  bool hasCapacities() {
    return monsterDetails != null && monsterDetails!.capabilities.where((element) => element != null).isNotEmpty;
  }

  bool hasAttacks() {
    return monsterDetails != null && monsterDetails!.attacks.where((element) => element != null).isNotEmpty;
  }

  List<String?> getSpecialCapabilities(creatureJson) {
    List<dynamic> pathsJson = creatureJson['special_capabilities'];
    return pathsJson.map((pathJson) => mapValue(pathJson)).toList();
  }

  MonsterProfile? getMonsterProfile(creatureJson) {
    String? label = getValueFromJsonWithArray(creatureJson, "profile", "label", "");
    int? level = int.parse(getValueFromJsonWithArray(creatureJson, "profile_level", "value", "0"));
    if(label != "") {
      return MonsterProfile(label, level);
    } else {
      return null;
    }
  }

  String showLimited(MonsterCapability capability) {
    return capability.isLimited! ? " (L) " : "";
  }

  String showMagical(MonsterCapability capability) {
    return capability.isMagical! ? " * " : "";
  }

  String showSuperiorAbility(String capabilityCode, Monster monster) {
    bool? superiorAbility = monster.superiorAbilities[capabilityCode];
    return superiorAbility == true ? "*" : "";
  }

  void changeCapabilitiesPanelState(int index) {
    var capabilitie = monsterDetails!.capabilities[index];
    capabilitie!.isOpen = !capabilitie.isOpen;
    notifyListeners();
  }

}
