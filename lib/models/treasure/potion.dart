import 'package:cocompagnon/models/treasure/treasure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class Potion extends MagicItem {
  MagicItemLevelCategory category;

  String printPrefix() {
    return "Potion de ";
  }

  String printCharges() {
    return "${getNbCharges()} charges";
  }

  int getNbCharges() {
    return category == MagicItemLevelCategory.minor ? 1 : 3;
  }

  Potion(this.category);
}

class HealPotion extends Potion {
  HealPotionType type;

  @override
  String print() {
    return "${super.printPrefix()}${type.label}\n${super.printCharges()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.heart_bottle;
  }

  Color? getIconColor() {
    return Colors.red;
  }

  HealPotion(this.type, super.nbCharge);
}

class CommonPotion extends Potion {
  PotionType type;

  @override
  String print() {
    return "${super.printPrefix()}${type.label}\n${super.printCharges()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.potion;
  }

  @override
  Color? getIconColor() {
    return Colors.blue;
  }

  CommonPotion(this.type, super.charge);
}

class RarePotion extends Potion {
  RarePotionType type;

  @override
  String print() {
    return "${super.printPrefix()}${type.label}\n${super.printCharges()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.bottled_bolt;
  }

  @override
  Color? getIconColor() {
    return Colors.green;
  }

  RarePotion(this.type, super.charge);
}

enum PotionCategory {
  heal(1, "Potion de soin"),
  common(4, "Potion commune"),
  rare(6, "Potion rare");

  const PotionCategory(this.score, this.label);

  final int score;
  final String label;
  static int dice = 6;
}

enum HealPotionType {
  lightHeal(1, "Soins légers"),
  mediumHeal(4, "Soins modérés"),
  delivrance(6, "Délivrance");

  const HealPotionType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 6;
}

enum PotionType {
  invisibilityDetection(1, "Détection de l’invisible (Ensorceleur)"),
  enlargement(2, "Agrandissement (Magicien)"),
  gaseousForm(3, "Forme gazeuse (Magicien)"),
  haste(4, "Hâte (Magicien)"),
  elementProtection(5, "Protection contre les éléments (Magicien, RD 10)"),
  waterBreathing(6, "Respiration aquatique (Magicien)"),
  mageArmor(7, "Armure de mage (Magicien)"),
  slowedFall(8, "Chute ralentie (Magicien)"),
  invisibility(9, "Invisibilité (Magicien)"),
  fly(10, "Vol (Magicien)");

  const PotionType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 10;
}

enum RarePotionType {
  animalLanguage(1, "Langage des animaux (Druide, 1d6 minutes)"),
  predatorMask(2, "Masque du prédateur (Druide)"),
  animalForm(3, "Forme animale (Druide, 1d6 minutes)"),
  sylvianWalk(4, "Marche sylvestre (Druide, 2d6 heures)"),
  treeForm(5, "Forme d’arbre (Druide, 2d6 minutes)"),
  barkSkin(6, "Peau d’écorce (Druide, +5 DEF)"),
  clairvoyance(7, "Clairvoyance (Ensorceleur, 1d6 tours)"),
  underPressure(8, "Sous tension (Ensorceleur)"),
  etherealForm(9, "Forme éthérée (Ensorceleur)"),
  imitation(10, "Imitation (Ensorceleur)"),
  fortifying(11, "Fortifiant (Forgesort)"),
  greekFire(12, "Feu grégeois (Forgesort)"),
  healingElixir(13, "Elixir de guérison (Forgesort)"),
  vague(14, "Flou (Magicien)"),
  succubusAppearance(15, "Aspect de la succube (Nécromancien)"),
  demonAppearance(16, "Aspect du démon (Nécromancien)"),
  deathMask(17, "Masque mortuaire (Nécromancien)"),
  spiderLegs(18, "Pattes d’araignée (Nécromancien)"),
  heavenlyWings(19, "Ailes célestes (Prêtre)"),
  sanctuary(20, "Sanctuaire (Prêtre)");

  const RarePotionType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 20;
}
