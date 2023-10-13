import 'package:cocompagnon/models/monster.dart';
import 'package:cocompagnon/models/treasure/cloth.dart';
import 'package:cocompagnon/models/treasure/consumeable.dart';
import 'package:cocompagnon/models/treasure/money.dart';
import 'package:cocompagnon/models/treasure/potion.dart';
import 'package:cocompagnon/models/treasure/treasure-table.dart';
import 'package:cocompagnon/models/treasure/treasure.dart';
import 'package:cocompagnon/models/treasure/weapon.dart';
import 'package:cocompagnon/utils/dice-utils.dart';
import 'package:cocompagnon/utils/shared-preferences-utils.dart';
import 'package:flutter/cupertino.dart';

class RandomTreasureController extends ChangeNotifier {
  MonsterType monsterType = MonsterType.humanoid;
  double treasureLevel = 0;

  TextEditingController monsterNcController = TextEditingController(text: "0");
  TextEditingController monsterModInt = TextEditingController(text: "0");

  List<Treasure> treasures = [];

  void updateMonsterCategory(String? value) {
    monsterType = MonsterType.fromName(value);
    calculateTreasureLevel();
  }

  void generateRandomTreasure(BuildContext context) {
    treasures = [];
    TreasureTableRow selectedRow = treasureTable.firstWhere((row) => treasureLevel <= row.treasureLevel);

    int moneyCount = sendDiceMultiple(selectedRow.moneyNumberOfDice, 6, 0);
    treasures.add(MoneyTreasure(selectedRow.moneyCoinType, moneyCount * selectedRow.coinMultiplier));

    if (selectedRow.minScoreToHaveJewels <= sendDiceMultiple(1, 20, 0)) {
      int jewelCount = sendDiceMultiple(selectedRow.jewelsDiceCount, selectedRow.jewelsDiceType, 0);
      treasures.add(JewelTreasure(selectedRow.jewelCoinType, jewelCount * selectedRow.jewelsMultiplier));
    }

    int nbOfMinorItems = sendDiceMultipleScoreToBeat(selectedRow.minorMagicItemDiceCount, selectedRow.minScoreToHaveMinorMagicItems, 0);
    if (nbOfMinorItems > 0) {
      addMagicItems(nbOfMinorItems, MagicItemLevelCategory.minor, treasures);
    }

    int nbOfMediumItems = sendDiceMultipleScoreToBeat(selectedRow.mediumMagicItemDiceCount, selectedRow.minScoreToHaveMediumMagicItems, 0);
    if (nbOfMediumItems > 0) {
      addMagicItems(nbOfMediumItems, MagicItemLevelCategory.medium, treasures);
    }

    int nbOfMajorItems = sendDiceMultipleScoreToBeat(selectedRow.majorMagicItemDiceCount, selectedRow.minScoreToHaveMajorMagicItems, 0);
    if (nbOfMajorItems > 0) {
      addMagicItems(nbOfMajorItems, MagicItemLevelCategory.major, treasures);
    }

    notifyListeners();
  }

  void addAMinorMagicItem(List<Treasure> treasures, MagicItemLevelCategory magicItemLevelCategory) {
    MinorMagicItemType itemType = MinorMagicItemType.values.reversed.firstWhere((type) => rollDice(MinorMagicItemType.dice) >= type.score);
    switch (itemType) {
      case MinorMagicItemType.potion:
        addPotionItem(treasures, magicItemLevelCategory);
        break;
      case MinorMagicItemType.scroll:
      case MinorMagicItemType.magicWand:
        addScrollOrMagicWandItem(itemType == MinorMagicItemType.scroll, treasures, magicItemLevelCategory);
        break;
      case MinorMagicItemType.stuffRank1:
      case MinorMagicItemType.stuffRank2:
        addStuffItem(treasures, itemType.magicLevel, magicItemLevelCategory);
        break;
    }
  }

  void addAMediumMagicItem(List<Treasure> treasures, MagicItemLevelCategory magicItemLevelCategory) {
    MediumMagicItemType itemType = MediumMagicItemType.values.reversed.firstWhere((type) => rollDice(MediumMagicItemType.dice) >= type.score);
    switch (itemType) {
      case MediumMagicItemType.potion:
        addPotionItem(treasures, magicItemLevelCategory);
        break;
      case MediumMagicItemType.scroll:
      case MediumMagicItemType.magicWand:
        addScrollOrMagicWandItem(itemType == MediumMagicItemType.scroll, treasures, magicItemLevelCategory);
        break;
      case MediumMagicItemType.stuffRank2:
      case MediumMagicItemType.stuffRank3:
      case MediumMagicItemType.stuffRank4:
        addStuffItem(treasures, itemType.magicLevel, magicItemLevelCategory);
        break;
    }
  }

  void addMagicItems(int remainingNbOfItem, MagicItemLevelCategory category, List<Treasure> treasures) {
    if (remainingNbOfItem > 0) {
      switch (category) {
        case MagicItemLevelCategory.minor:
          addAMinorMagicItem(treasures, category);
          break;
        case MagicItemLevelCategory.medium:
          addAMediumMagicItem(treasures, category);
          break;
        case MagicItemLevelCategory.major:
          MajorMagicItemType itemType = MajorMagicItemType.values.reversed.firstWhere((type) => rollDice(MajorMagicItemType.dice) >= type.score);
          addStuffItem(treasures, itemType.magicLevel, category);
          break;
      }

      remainingNbOfItem--;
      addMagicItems(remainingNbOfItem, category, treasures);
    }
  }

  void addStuffItem(List<Treasure> treasures, int magicLevel, MagicItemLevelCategory magicItemLevelCategory) {
    MediumOrMajorMagicItemCategory category = getMagicItemCategory(magicItemLevelCategory);

    switch (category) {
      case MediumOrMajorMagicItemCategory.weapon:
        addWeapon(magicLevel, treasures);
        break;
      case MediumOrMajorMagicItemCategory.armor:
        addArmor(magicLevel, treasures);
        break;
      case MediumOrMajorMagicItemCategory.powerItem:
        List<Skill> skills = [];
        addSkill(skills, magicLevel);
        treasures.add(PowerItem(skills, magicLevel));
        break;
      case MediumOrMajorMagicItemCategory.caracItem:
        CaracType caracType = CaracType.values.reversed.firstWhere((type) => rollDice(CaracType.dice) >= type.score);
        treasures.add(CaracItem(caracType, magicLevel));
        break;
    }
  }

  MediumOrMajorMagicItemCategory getMagicItemCategory(MagicItemLevelCategory magicItemLevelCategory) {
    switch (magicItemLevelCategory) {
      case MagicItemLevelCategory.minor:
        MinorMagicItemCategory minorCategory = MinorMagicItemCategory.values.reversed.firstWhere((category) => rollDice(MinorMagicItemCategory.dice) >= category.score);
        return MediumOrMajorMagicItemCategory.values.reversed.firstWhere((category) => category.name == minorCategory.name);
      case MagicItemLevelCategory.medium:
      case MagicItemLevelCategory.major:
        return MediumOrMajorMagicItemCategory.values.reversed.firstWhere((category) => rollDice(MediumOrMajorMagicItemCategory.dice) >= category.score);
    }
  }

  void addSkill(List<Skill> skills, int magicLevel) {
    ProfileType profile = ProfileType.values.reversed.firstWhere((profile) => rollDice(ProfileType.dice) >= profile.score);
    PowerItemRank rank = PowerItemRank.values.reversed.firstWhere((rank) => rollDice(PowerItemRank.dice) >= rank.score);

    if (rank.rank >= magicLevel) {
      if (rank.rank > magicLevel) {
        rank = PowerItemRank.values.reversed.firstWhere((powerItemRank) => magicLevel >= powerItemRank.rank);
      }
      skills.add(Skill(rank, profile));
    } else {
      skills.add(Skill(rank, profile));
      magicLevel = magicLevel - rank.rank;
      addSkill(skills, magicLevel);
    }
  }

  void addArmor(int magicLevel, List<Treasure> treasures) {
    var armorType = ArmorType.values.reversed.firstWhere((type) => rollDice(ArmorType.dice) >= type.score);

    ArmorAdditionalEffect? additionalEffect;
    ArmorAdditionalEffect? secondAddtionalEffect;
    int bonusArmor = magicLevel;

    var rollAdditionalEffect = rollDice(6);
    if (rollAdditionalEffect < magicLevel) {
      bonusArmor--;
      additionalEffect = ArmorAdditionalEffect.values.reversed.firstWhere((additionalEffect) => rollDice(ArmorAdditionalEffect.dice) >= additionalEffect.score);
      if (additionalEffect == ArmorAdditionalEffect.doubleSpecialEffect) {
        additionalEffect = ArmorAdditionalEffect.values.reversed.firstWhere((additionalEffect) => rollDice(ArmorAdditionalEffect.secondDice) >= additionalEffect.score);
        secondAddtionalEffect = ArmorAdditionalEffect.values.reversed.firstWhere((additionalEffect) => rollDice(ArmorAdditionalEffect.secondDice) >= additionalEffect.score);
      }
    }

    treasures.add(Armor(armorType, additionalEffect, secondAddtionalEffect, bonusArmor, magicLevel));
  }

  void addWeapon(int magicLevel, List<Treasure> treasures) {
    var weaponCategory = WeaponCategory.values.reversed.firstWhere((category) => rollDice(WeaponCategory.dice) >= category.score);
    WeaponAdditionalEffect? additionalEffect;
    WeaponAdditionalEffect? secondAddtionalEffect;
    int damageBonus = magicLevel;
    var rollAdditionalEffect = rollDice(6);
    if (rollAdditionalEffect < magicLevel) {
      damageBonus--;
      additionalEffect = WeaponAdditionalEffect.values.reversed.firstWhere((effect) => rollDice(WeaponAdditionalEffect.dice) >= effect.score);
      if (additionalEffect == WeaponAdditionalEffect.doubleSpecialEffect) {
        additionalEffect = WeaponAdditionalEffect.values.reversed.firstWhere((effect) => rollDice(WeaponAdditionalEffect.secondDice) >= effect.score);
        secondAddtionalEffect = WeaponAdditionalEffect.values.reversed.firstWhere((effect) => rollDice(WeaponAdditionalEffect.secondDice) >= effect.score);
      }
    }

    switch (weaponCategory) {
      case WeaponCategory.melee:
        var weaponType = MeleeWeaponType.values.reversed.firstWhere((type) => rollDice(MeleeWeaponType.dice) >= type.score);
        treasures.add(MeleeWeapon(weaponType, additionalEffect, secondAddtionalEffect, magicLevel, damageBonus));
        break;
      case WeaponCategory.range:
        var weaponType = RangeWeaponType.values.reversed.firstWhere((type) => rollDice(RangeWeaponType.dice) >= type.score);
        treasures.add(RangeWeapon(weaponType, additionalEffect, secondAddtionalEffect, magicLevel, damageBonus));
        break;
      case WeaponCategory.magicScepter:
        var weaponType = MagicScepterType.values.reversed.firstWhere((type) => rollDice(MagicScepterType.dice) >= type.score);
        treasures.add(MagicScepter(weaponType, additionalEffect, secondAddtionalEffect, magicLevel, damageBonus));
        break;
    }
  }

  void addScrollOrMagicWandItem(bool isScroll, List<Treasure> treasures, MagicItemLevelCategory magicItemLevelCategory) {
    int rank = getSkillRank(magicItemLevelCategory);
    var itemPath = ItemPath.values.reversed.firstWhere((s) => rollDice(ItemPath.dice) >= s.score);
    var isMagic = SharedPreferencesUtils.getCapacity(itemPath, rank).isMagic;
    if (!isMagic) {
      addScrollOrMagicWandItem(isScroll, treasures, magicItemLevelCategory);
    } else {
      if (isScroll) {
        treasures.add(Scroll(itemPath, rank));
      } else {
        treasures.add(MagicWand(itemPath, rank));
      }
    }
  }

  int getSkillRank(MagicItemLevelCategory magicItemLevelCategory) {
    int rank;
    if (magicItemLevelCategory == MagicItemLevelCategory.minor) {
      rank = MinorSkillItemRank.values.reversed.firstWhere((rank) => rollDice(MinorSkillItemRank.dice) >= rank.score).rank;
    } else {
      rank = MediumSkillItemRank.values.reversed.firstWhere((rank) => rollDice(MediumSkillItemRank.dice) >= rank.score).rank;
    }
    return rank;
  }

  void addPotionItem(List<Treasure> treasures, MagicItemLevelCategory magicItemLevelCategory) {
    PotionCategory category = PotionCategory.values.reversed.firstWhere((category) => rollDice(PotionCategory.dice) >= category.score);
    switch (category) {
      case PotionCategory.heal:
        var healPotionType = HealPotionType.values.reversed.firstWhere((type) => rollDice(HealPotionType.dice) >= type.score);
        treasures.add(HealPotion(healPotionType, magicItemLevelCategory));
        break;
      case PotionCategory.common:
        PotionType potionType = PotionType.values.reversed.firstWhere((p) => rollDice(PotionType.dice) >= p.score);
        treasures.add(CommonPotion(potionType, magicItemLevelCategory));
        break;
      case PotionCategory.rare:
        RarePotionType rarePotionType = RarePotionType.values.reversed.firstWhere((p) => rollDice(RarePotionType.dice) >= p.score);
        treasures.add(RarePotion(rarePotionType, magicItemLevelCategory));
    }
  }

  void calculateTreasureLevel() {
    var modInt = monsterModInt.text != "" ? monsterModInt.text : "0";
    var nc = monsterNcController.text != "" ? monsterNcController.text : "0";
    treasureLevel = monsterType.treasureModifier.toDouble() + double.parse(modInt) + double.parse(nc);
    notifyListeners();
  }

  String printTreasureLevel() {
    return treasureLevel.toStringAsFixed(treasureLevel.truncateToDouble() == treasureLevel ? 0 : 2);
  }

  double calculeTreasureHeight(Treasure treasure) {
    if (treasure is MoneyTreasure || treasure is JewelTreasure) {
      return 50;
    } else if (treasure is Weapon || treasure is Armor) {
      if (treasure is Weapon && treasure.secondAdditionalEffect != null) {
        return 90;
      }
      if (treasure is Armor && treasure.additionalEffect != null) {
        return 90;
      }
      return 70;
    } else if (treasure is Scroll || treasure is CaracItem) {
      return 70;
    } else if (treasure is Potion) {
      if (treasure is HealPotion) {
        return 70;
      } else {
        return 90;
      }
    } else if (treasure is MagicWand) {
      return 90;
    } else if (treasure is PowerItem) {
      int height = 70;

      int lenght = treasure.skills.length;

      return height + (lenght * 20);
    }
    return 120;
  }
}
