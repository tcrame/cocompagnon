import 'dart:math';

import 'package:cocompagnon/models/belligerent.dart';
import 'package:cocompagnon/utils/shared-preferences-utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:uuid/uuid.dart';

import '../pages/monsters-details-page.dart';

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

  TextEditingController strengthController = TextEditingController();
  TextEditingController dexterityController = TextEditingController();
  TextEditingController constitutionController = TextEditingController();
  TextEditingController intelligenceController = TextEditingController();
  TextEditingController wisdomController = TextEditingController();
  TextEditingController charismaController = TextEditingController();
  TextEditingController tokenUrlController = TextEditingController();

  Set<SuperiorCaracteristics> superiorCaracteristics = {};

  BelligerentType? belligerentType = BelligerentType.ally;
  BelligerentDebuffType belligerentDebuffType = BelligerentDebuffType.blind;
  int turn = 1;
  bool isInitiativeOptionalRuleActivated = true;

  List<Belligerent> belligerents = <Belligerent>[];


  void updateBelligerentType(BelligerentType? belligerentType) {
    this.belligerentType = belligerentType;
    notifyListeners();
  }

  void updateBelligerentDebuffType(String? type) {
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

  addBelligerent(String name, int defense, int initiative, int currentPv, int maxPv, BelligerentType? belligerentType, int? monsterId, int? strength, int? dexterity, int? constitution,
      int? intelligence, int? wisdom, int? charisma, Map<String, bool> superiorAbilities, String? tokenUrl) {
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
        debuffs: <BelligerentDebuff>[],
        monsterId: monsterId,
        strength: strength,
        dexterity: dexterity,
        constitution: constitution,
        intelligence: intelligence,
        wisdom: wisdom,
        charisma: charisma,
        superiorAbilities: superiorAbilities,
        tokenUrl: tokenUrl);
    belligerents.add(newBelligerent);
    SharedPreferencesUtils.saveBelligerent(newBelligerent);
    sortBelligerentsAndRefresh();
  }

  void editBelligerent(String uuid, String name, int defense, int initiative, int currentPv, int maxPv, BelligerentType? belligerentType, int? strength, int? dexterity, int? constitution,
      int? intelligence, int? wisdom, int? charisma, Map<String, bool> superiorCaracs, String? tokenUrl) {
    Belligerent belligerentToUpdate = belligerents.firstWhere((element) => element.uuid == uuid);
    belligerentToUpdate.name = name;
    belligerentToUpdate.defense = defense;
    belligerentToUpdate.initiative = initiative;
    belligerentToUpdate.maxPv = maxPv;
    belligerentToUpdate.currentPv = currentPv;
    belligerentToUpdate.belligerentType = belligerentType;
    belligerentToUpdate.strength = strength;
    belligerentToUpdate.dexterity = dexterity;
    belligerentToUpdate.constitution = constitution;
    belligerentToUpdate.intelligence = intelligence;
    belligerentToUpdate.wisdom = wisdom;
    belligerentToUpdate.charisma = charisma;
    belligerentToUpdate.superiorAbilities = superiorCaracs;
    belligerentToUpdate.tokenUrl = tokenUrl;
    SharedPreferencesUtils.saveBelligerent(belligerentToUpdate);
    sortBelligerentsAndRefresh();
  }

  void rollInitiatives() {
    for (var beligerent in belligerents) {
      beligerent.recalculateInitiative(isInitiativeOptionalRuleActivated);
      beligerent.recalculateDebuffs();
      SharedPreferencesUtils.saveBelligerent(beligerent);
    }
    sortBelligerentsAndRefresh();
    turn++;
    SharedPreferencesUtils.saveCurrentTurn(turn);
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

  void removeBelligerent(String uuid) {
    belligerents.removeWhere((element) => element.uuid == uuid);
    SharedPreferencesUtils.deleteBelligerent(uuid);
    sortBelligerentsAndRefresh();
  }

  void sortBelligerentsAndRefresh() {
    belligerents.sort((a, b) => b.currentInitiative.compareTo(a.currentInitiative));
    SharedPreferencesUtils.saveBelligerentIds(belligerents.map((e) => e.uuid).toList());
    notifyListeners();
  }

  void initControllers(String updateUuid) {
    if (updateUuid != "") {
      superiorCaracteristics = {};
      var belligerent = belligerents.firstWhere((element) => element.uuid == updateUuid);
      nameController.text = belligerent.name;
      defenseController.text = '${belligerent.defense}';
      initiativeController.text = '${belligerent.initiative}';
      maxPvController.text = '${belligerent.maxPv}';
      currentPvController.text = '${belligerent.currentPv}';
      strengthController.text = belligerent.strength != null ? '${belligerent.strength}' : '';
      dexterityController.text = belligerent.dexterity != null ? '${belligerent.dexterity}' : '';
      constitutionController.text = belligerent.constitution != null ? '${belligerent.constitution}' : '';
      intelligenceController.text = belligerent.intelligence != null ? '${belligerent.intelligence}' : '';
      wisdomController.text = belligerent.wisdom != null ? '${belligerent.wisdom}' : '';
      charismaController.text = belligerent.charisma != null ? '${belligerent.charisma}' : '';
      tokenUrlController.text = belligerent.tokenUrl != null ? '${belligerent.tokenUrl}' : '';
      belligerentType = belligerent.belligerentType;
      belligerent.superiorAbilities.entries.forEach((entry) {
        if (entry.value == true) {
          superiorCaracteristics.add(SuperiorCaracteristics.fromCode(entry.key));
        }
      });
    }
  }

  void addDebuffToBelligerentById(String updateUuid) {
    var belligerent = belligerents.firstWhere((element) => element.uuid == updateUuid);
    belligerent.debuffs.add(BelligerentDebuff(type: belligerentDebuffType, description: debuffCommentController.text, durationInTurn: int.parse(debuffNbTurnsController.text)));
    SharedPreferencesUtils.saveBelligerent(belligerent);
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

  void resetTurns() {
    turn = 1;
    SharedPreferencesUtils.saveCurrentTurn(turn);
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

  String printCaracMod(int? mod) {
    if (mod != null) {
      if (mod > 0) {
        return '+$mod';
      } else {
        return '$mod';
      }
    } else {
      return '';
    }
  }

  String calculateMod(int? flatCarac) {
    if (flatCarac != null) {
      if (flatCarac >= 10) {
        int mod = (flatCarac % 2 == 0 ? (flatCarac - 10) / 2 : (flatCarac - 11) / 2).round();
        return '+$mod';
      } else {
        int mod = (flatCarac % 2 == 0 ? flatCarac / 2 : (flatCarac - 1) / 2).round();
        return '-$mod';
      }
    } else {
      return '';
    }
  }

  String showSuperiorAbility(String capabilityCode, Belligerent belligerent) {
    bool? superiorAbility = belligerent.superiorAbilities[capabilityCode];
    return superiorAbility == true ? "*" : "";
  }

  void initRemainingDebuffForBelligerent(String uuid) {
    var remainingDebuffs = getRemainingDebuffsForBelligerent(uuid);
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

    if (belligerent.currentPv < 0) {
      belligerent.currentPv = 0;
    }
    notifyListeners();
  }

  void healDamage(Belligerent belligerent) {
    var healthToHeal = removeDamageController.text != "" ? int.parse(removeDamageController.text) : 0;
    belligerent.currentPv = belligerent.currentPv + healthToHeal;

    if (belligerent.currentPv > belligerent.maxPv) {
      belligerent.currentPv = belligerent.maxPv;
    }
    notifyListeners();
  }

  void toggleInitiativeOptionalRule(bool state) {
    isInitiativeOptionalRuleActivated = !isInitiativeOptionalRuleActivated;
    SharedPreferencesUtils.saveInitiativeOptionalRuleState(isInitiativeOptionalRuleActivated);
    notifyListeners();
  }

  void restoreBelligerents() {
    SharedPreferencesUtils.restoreBelligerents().then((value) {
      belligerents = value;
      notifyListeners();
    });
  }

  void restoreCurrentTurn() {
    SharedPreferencesUtils.restoreCurrentTurn().then((value) {
      turn = value;
      notifyListeners();
    });
  }

  void restoreInitiativeOptionalRuleState() {
    SharedPreferencesUtils.restoreInitiativeOptionalRuleState().then((value) {
      isInitiativeOptionalRuleActivated = value;
    });
  }

  void navigateToDetailsPage(context, Belligerent belligerent) {
    if (belligerent.monsterId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          var monsterId = belligerent.monsterId;
          var monstersJson = SharedPreferencesUtils.allMonstersJson[monsterId.toString()];
          return MonstersDetailPage(monster: SharedPreferencesUtils.buildMonster(monsterId!, monstersJson));
        }),
      );
    }
  }

  void removeOrAddSuperiorCaracteristicSelection(bool selected, SuperiorCaracteristics superiorCaract) {
    print("$selected = $superiorCaract");
    if (selected) {
      print("$superiorCaracteristics");
      superiorCaracteristics.remove(superiorCaract);
    } else {
      superiorCaracteristics.add(superiorCaract);
    }
    notifyListeners();
  }

  showDebuffIcon(Belligerent belligerent) {
    if(belligerent.debuffs.length == 1) {
      return belligerent.debuffs.first.type!.icon;
    } else if(belligerent.debuffs.length > 1) {
      return RpgAwesome.aura;
    }
    return Icons.disabled_by_default;
  }
}
