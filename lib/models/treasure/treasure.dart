import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

import 'money.dart';

class TreasureTableRow {
  double treasureLevel;
  int moneyNumberOfDice;
  int coinMultiplier;
  CoinType moneyCoinType;
  int minScoreToHaveJewels;
  int jewelsDiceCount;
  int jewelsDiceType;
  int jewelsMultiplier;
  CoinType jewelCoinType;
  int minScoreToHaveMinorMagicItems;
  int minorMagicItemDiceCount;
  int minScoreToHaveMediumMagicItems;
  int mediumMagicItemDiceCount;
  int minScoreToHaveMajorMagicItems;
  int majorMagicItemDiceCount;

  TreasureTableRow(
      this.treasureLevel,
      this.moneyNumberOfDice,
      this.coinMultiplier,
      this.moneyCoinType,
      this.minScoreToHaveJewels,
      this.jewelsDiceCount,
      this.jewelsDiceType,
      this.jewelsMultiplier,
      this.jewelCoinType,
      this.minScoreToHaveMinorMagicItems,
      this.minorMagicItemDiceCount,
      this.minScoreToHaveMediumMagicItems,
      this.mediumMagicItemDiceCount,
      this.minScoreToHaveMajorMagicItems,
      this.majorMagicItemDiceCount);
}

class Treasure {
  String print() {
    return "";
  }

  IconData getIcon() {
    return RpgAwesome.round_bottom_flask;
  }

  Color? getIconColor() {
    return Colors.black;
  }
}

class MagicItem extends Treasure {}

enum MinorMagicItemCategory {
  weapon(1),
  armor(3),
  powerItem(5);

  const MinorMagicItemCategory(this.score);

  final int score;
  static int dice = 6;
}

enum MediumOrMajorMagicItemCategory {
  weapon(1),
  armor(4),
  caracItem(7),
  powerItem(9);

  const MediumOrMajorMagicItemCategory(this.score);

  final int score;
  static int dice = 12;
}

enum MinorMagicItemType {
  potion(1, 1),
  scroll(5, 1),
  magicWand(7, 1),
  stuffRank1(8, 1),
  stuffRank2(12, 2);

  const MinorMagicItemType(this.score, this.magicLevel);

  final int score;
  final int magicLevel;
  static int dice = 12;
}

enum MediumMagicItemType {
  potion(1, 1),
  scroll(3, 1),
  magicWand(4, 1),
  stuffRank2(5, 2),
  stuffRank3(9, 3),
  stuffRank4(12, 4);

  const MediumMagicItemType(this.score, this.magicLevel);

  final int score;
  final int magicLevel;
  static int dice = 12;
}

enum MajorMagicItemType {
  stuffRank3(1, 3),
  stuffRank4(4, 4),
  stuffRank5(10, 5);

  const MajorMagicItemType(this.score, this.magicLevel);

  final int score;
  final int magicLevel;
  static int dice = 12;
}

enum MagicItemLevelCategory {
  minor,
  medium,
  major;
}

enum ItemPath {
  animalLanguage(1, "Voie de l’air", 1),
  predatorMask(2, "Voie de la divination", 1),
  animalForm(3, "Voie de l’envoûteur", 1),
  sylvianWalk(4, "Voie des illusions", 1),
  treeForm(5, "Voie de l’invocation", 1),
  barkSkin(6, "Voie de la magie des arcanes", 2),
  clairvoyance(7, "Voie de la magie destructrice", 2),
  underPressure(8, "Voie de la magie élémentaire", 2),
  etherealForm(9, "Voie de la magie protectrice", 2),
  imitation(10, "Voie de la magie universelle", 2),
  fortifying(11, "Voie du démon", 3),
  greekFire(12, "Voie de la mort", 3),
  healingElixir(13, "Voie de l’outre-tombe", 3),
  vague(14, "Voie du sang", 3),
  succubusAppearance(15, "Voie de la sombre magie", 3),
  demonAppearance(16, "Voie de la foi", 4),
  deathMask(17, "Voie de la prière", 4),
  spiderLegs(18, "Voie des soins", 4),
  heavenlyWings(19, "Voie de la spiritualité", 4),
  sanctuary(20, "Voie des végétaux", 5);

  const ItemPath(this.score, this.label, this.profileCode);

  final int score;
  final String label;
  final int profileCode;
  static int dice = 20;
}

enum TreasureType {
  money("en monais"),
  jewels("en pierre précieuse"),
  minorMagicItem("objet magique mineur"),
  mediumMagicItem("objet magique moyen"),
  majorMagicItem("objet magique majeur");

  const TreasureType(this.label);

  final String label;
}
