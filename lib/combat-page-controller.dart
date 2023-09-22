import 'dart:convert';
import 'dart:math';

import 'package:cocompagnon/belligerent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CombatPageController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController defenseController = TextEditingController();
  TextEditingController initiativeController = TextEditingController();
  TextEditingController maxPvController = TextEditingController();
  TextEditingController currentPvController = TextEditingController();
  TextEditingController debuffCommentController = TextEditingController();
  TextEditingController debuffNbTurnsController = TextEditingController();
  TextEditingController addDamageController = TextEditingController();
  TextEditingController removeDamageController = TextEditingController();
  BelligerentType? belligerentType = BelligerentType.ally;
  BelligerentDebuffType belligerentDebuffType = BelligerentDebuffType.blind;
  int turn = 1;

  List<Belligerent> belligerents = <Belligerent>[];

  updateBelligerentType(BelligerentType? belligerentType) {
    this.belligerentType = belligerentType;
    notifyListeners();
  }

  updateBelligerentDebuffType(String? type) {
    belligerentDebuffType = BelligerentDebuffType.values.firstWhere((e) => e.name == type);
    debuffCommentController.text = belligerentDebuffType.description;
    notifyListeners();
  }

  double getCurrentRatioOfPvByUuid(String uuid) {
    var belligerent = belligerents.firstWhere((element) => element.uuid == uuid);
    return belligerent.getRatioOfPv();
  }

  MaterialColor getBelligerentBarColor(String uuid) {
    var belligerent = belligerents.firstWhere((element) => element.uuid == uuid);
    return belligerent.getBarColor();
  }

  var uuidGenerator = const Uuid();

  addBelligerent(String name, int defense, int initiative, int currentPv, int maxPv, BelligerentType? belligerentType) {
    int currentInit = initiative + Random().nextInt(6) + 1;
    String string = uuidGenerator.v1();
    var newBelligerent = Belligerent(
        name: name,
        defense: defense,
        initiative: initiative,
        currentPv: currentPv,
        maxPv: maxPv,
        belligerentType: belligerentType,
        currentInitiative: currentInit,
        uuid: string,
        debuffs: <BelligerentDebuff>[]);
    belligerents.add(newBelligerent);
    saveBelligerent(newBelligerent);
    sortBelligerentsAndRefresh();
  }

  editBelligerent(String uuid, String name, int defense, int initiative, int currentPv, int maxPv, BelligerentType? belligerentType) {
    var belligerentToUpdate = belligerents.firstWhere((element) => element.uuid == uuid);
    belligerentToUpdate.name = name;
    belligerentToUpdate.defense = defense;
    belligerentToUpdate.initiative = initiative;
    belligerentToUpdate.maxPv = maxPv;
    belligerentToUpdate.currentPv = currentPv;
    belligerentToUpdate.belligerentType = belligerentType;
    saveBelligerent(belligerentToUpdate);
    sortBelligerentsAndRefresh();
  }

  rollInitiatives() {
    for (var beligerent in belligerents) {
      beligerent.recalculateInitiative();
      beligerent.recalculateDebuffs();
      saveBelligerent(beligerent);
    }
    sortBelligerentsAndRefresh();
    turn++;
    saveCurrentTurn();
  }

  String getModalTitle(String uuid) {
    if (uuid == "") {
      return "Ajouter un belligérent";
    } else {
      String name = belligerents.firstWhere((element) => element.uuid == uuid).name;
      return "Modifier ${name}";
    }
  }

  String getModalDebuffTitle(String uuid) {
    if (uuid == "") {
      return "Ajouter un belligérent";
    } else {
      String name = belligerents.firstWhere((element) => element.uuid == uuid).name;
      return "Ajouter un debuff à ${name}";
    }
  }

  removeBelligerent(String uuid) {
    belligerents.removeWhere((element) => element.uuid == uuid);
    deleteBelligerent(uuid);
    sortBelligerentsAndRefresh();
  }

  void sortBelligerentsAndRefresh() {
    belligerents.sort((a, b) => b.currentInitiative.compareTo(a.currentInitiative));
    saveBelligerentIds(belligerents.map((e) => e.uuid).toList());
    notifyListeners();
  }

  void initControllers(String updateUuid) {
    if (updateUuid != "") {
      var belligerent = belligerents.firstWhere((element) => element.uuid == updateUuid);
      nameController.text = belligerent.name;
      defenseController.text = '${belligerent.defense}';
      initiativeController.text = '${belligerent.initiative}';
      maxPvController.text = '${belligerent.maxPv}';
      currentPvController.text = '${belligerent.currentPv}';
      belligerentType = belligerent.belligerentType;
    }
  }

  void addDebuffToBelligerentById(String updateUuid) {
    var belligerent = belligerents.firstWhere((element) => element.uuid == updateUuid);
    belligerent.debuffs.add(BelligerentDebuff(type: belligerentDebuffType, description: debuffCommentController.text, durationInTurn: int.parse(debuffNbTurnsController.text)));

    saveBelligerent(belligerent);

    notifyListeners();
  }

  Future<void> saveBelligerent(Belligerent belligerent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(belligerent.uuid, jsonEncode(belligerent.toJson()));
  }

  Future<void> saveCurrentTurn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentTurn", turn);
  }

  Future<void> restoreCurrentTurn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentTurn = prefs.getInt("currentTurn");
    turn = currentTurn ?? 1;
  }

  Future<void> deleteBelligerent(String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(uuid);
  }

  Future<void> saveBelligerentIds(List<String> belligerentIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("belligerentIds", belligerentIds);
  }

  Future<Belligerent> restoreBelligerent(String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? string = prefs.getString(uuid);
    return Belligerent.fromJson(json.decode(string.toString()));
  }

  Future<void> restoreBelligerents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var ids = prefs.getStringList("belligerentIds");
    belligerents = ids != null ? ids.map((id) => Belligerent.fromJson(json.decode(prefs.getString(id).toString()))).toList() : <Belligerent>[];
    notifyListeners();
  }

  void initEditDebuffControllers(String updateUuid, BelligerentDebuff debuff) {
    debuffCommentController.text = debuff.description;
    debuffNbTurnsController.text = '${debuff.durationInTurn}';
  }

  void removeDebuffToBelligerent(String updateUuid, BelligerentDebuff debuff) {
    var belligerent = belligerents.firstWhere((element) => element.uuid == updateUuid);
    belligerent.debuffs.remove(debuff);
    notifyListeners();
  }

  void updateDebuffToBelligerentById(String updateUuid, BelligerentDebuff debuffToUpdate) {
    debuffToUpdate.description = debuffCommentController.text;
    debuffToUpdate.durationInTurn = int.parse(debuffNbTurnsController.text);
    notifyListeners();
  }

  resetTurns() {
    turn = 1;
    saveCurrentTurn();
    notifyListeners();
  }

  Iterable<BelligerentDebuffType> getRemainingDebuffsForBelligerent(String updateUuid) {
    var belligerent = belligerents.firstWhere((element) => element.uuid == updateUuid);
    var remainingBelligerents = BelligerentDebuffType.values.where((debuffType) => !belligerent.debuffs.any((debuff) => debuff.type == debuffType));
    if (remainingBelligerents.isNotEmpty) {
      return remainingBelligerents;
    } else {
      return <BelligerentDebuffType>[BelligerentDebuffType.other];
    }
  }

  void initRemainingDebuffForBelligerent(String uuid) {
    var remainingDebuffs = this.getRemainingDebuffsForBelligerent(uuid);
    if (remainingDebuffs.isNotEmpty) {
      belligerentDebuffType = remainingDebuffs.first;
    } else {
      belligerentDebuffType = BelligerentDebuffType.other;
    }
    debuffCommentController.text = belligerentDebuffType.description;
    debuffNbTurnsController.text = '1';
  }

  void removeHealthFromBelligerent(Belligerent belligerent) {
    if (belligerent.currentPv > 0) {
      belligerent.currentPv = belligerent.currentPv - 1;
      notifyListeners();
    }
  }

  void addHealthFromBelligerent(Belligerent belligerent) {
    if (belligerent.currentPv < belligerent.maxPv) {
      belligerent.currentPv = belligerent.currentPv + 1;
      notifyListeners();
    }
  }

  void resetDmControllers() {
    removeDamageController.text = "";
    addDamageController.text = "";
  }

  void inflictDamage(Belligerent belligerent) {
    var damages = addDamageController.text != "" ? int.parse(addDamageController.text) : 0;
    belligerent.currentPv = belligerent.currentPv - damages;

    if(belligerent.currentPv < 0) {
      belligerent.currentPv = 0;
    }
    notifyListeners();
  }

  void healDamage(Belligerent belligerent) {
    var healthToHeal = removeDamageController.text != "" ? int.parse(removeDamageController.text) : 0;
    belligerent.currentPv = belligerent.currentPv + healthToHeal;

    if(belligerent.currentPv > belligerent.maxPv) {
      belligerent.currentPv = belligerent.maxPv;
    }
    notifyListeners();
  }
}
