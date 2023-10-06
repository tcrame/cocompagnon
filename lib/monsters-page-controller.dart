import 'package:cocompagnon/monster.dart';
import 'package:cocompagnon/shared-preferences-utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'belligerent.dart';
import 'monster-ids.dart';
import 'monsters-details-page.dart';

class MonstersPageController extends ChangeNotifier {
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

  Future<void> loadAllCreaturesLocally() async {
    if (SharedPreferencesUtils.allMonsters.length != monsterIds.length) {
      SharedPreferencesUtils.allMonsters = [];
      SharedPreferencesUtils.readFileAsync().whenComplete(() => sortAllMonsterAndNotify());
    }
  }

  Future<void> loadAllCreatures() async {
    if (SharedPreferencesUtils.allMonsters.length != monsterIds.length) {
      SharedPreferencesUtils.allMonsters = [];
      for (var id in monsterIds) {
        SharedPreferencesUtils.restoreMonster(id).then((value) => SharedPreferencesUtils.loadCreature(value, id)).whenComplete(() => sortAllMonsterAndNotify());
      }
    } else {}
  }

  sortAllMonsterAndNotify() {
    filteredMonsters = [];
    filteredMonsters.addAll(SharedPreferencesUtils.allMonsters);

    sortMonsterAndNotify();
  }

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

  String printCaracMod(int mod) {
    if (mod > 0) {
      return '+$mod';
    } else {
      return '$mod';
    }
  }

  runFilter(String enteredKeyword) {
    currentKeyWords = enteredKeyword;
    applyFilters();
  }

  void applyFilters() {
    List<Monster> results = [];
    if (currentKeyWords.isEmpty) {
      results = SharedPreferencesUtils.allMonsters;
    } else {
      results = SharedPreferencesUtils.allMonsters.where((monster) => monster.name.toLowerCase().contains(currentKeyWords.toLowerCase())).toList();
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
    addBelligerent(monster);
  }

  addBelligerent(Monster monster) {
    int currentInit = monster.initiative;
    String uuid = uuidGenerator.v1();
    print(monster.superiorAbilities);
    var newBelligerent = Belligerent(
        name: monster.name,
        defense: monster.defense,
        initiative: monster.initiative,
        currentPv: monster.healthPoint,
        maxPv: monster.healthPoint,
        belligerentType: BelligerentType.enemy,
        currentInitiative: currentInit,
        uuid: uuid,
        debuffs: <BelligerentDebuff>[],
        monsterId: monster.id,
        strength: calculateFlatCarac(monster.strength),
        dexterity: calculateFlatCarac(monster.dexterity),
        constitution: calculateFlatCarac(monster.constitution),
        intelligence: calculateFlatCarac(monster.intelligence),
        wisdom: calculateFlatCarac(monster.wisdom),
        charisma: calculateFlatCarac(monster.charisma),
        superiorAbilities: monster.superiorAbilities,
        tokenUrl: monster.creatureTokenUrl);
    SharedPreferencesUtils.saveBelligerent(newBelligerent);
    SharedPreferencesUtils.addInBelligerentIds(uuid);
  }

  int calculateFlatCarac(int caracModifier) {
    return 10 + (caracModifier * 2);
  }

  void changeSortingDirection(MonsterOrderBy orderBy) {
    currentOrderBy = orderBy;
    sortMonsterAndNotify();
  }

  String showSuperiorAbility(String capabilityCode, Monster monster) {
    bool? superiorAbility = monster.superiorAbilities[capabilityCode];
    return superiorAbility != null && superiorAbility == true ? "*" : "";
  }

  void navigateToDetailsPage(context, int? monsterId) {
    if (monsterId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          var monstersJson = SharedPreferencesUtils.allMonstersJson[monsterId.toString()];
          return MonstersDetailPage(monster: SharedPreferencesUtils.buildMonster(monsterId!, monstersJson));
        }),
      );
    }
  }
}
