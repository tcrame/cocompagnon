import 'package:cocompagnon/models/treasure/cloth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class Weapon extends Stuff {
  WeaponAdditionalEffect? additionalEffect;
  WeaponAdditionalEffect? secondAdditionalEffect;
  int damageBonus;
  WeaponCategory category;

  String printAdditionalEffect() {
    return additionalEffect != null ? "de ${additionalEffect!.label}" : "";
  }

  String printSecondAdditionalEffect() {
    return secondAdditionalEffect != null ? "et de ${secondAdditionalEffect!.label}" : "";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.crossbow;
  }

  Weapon(this.category, this.additionalEffect, this.secondAdditionalEffect, this.damageBonus, super.magicLevel);
}

class MeleeWeapon extends Weapon {
  MeleeWeaponType type;

  @override
  String print() {
    return "${type.label} +$damageBonus (${category.label}) ${printAdditionalEffect()} ${printSecondAdditionalEffect()}\n${super.print()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.crossed_swords;
  }

  @override
  Color? getIconColor() {
    return Colors.grey[600];
  }

  MeleeWeapon(this.type, WeaponAdditionalEffect? additionalEffect, WeaponAdditionalEffect? secondAdditionalEffect, int damageBonus, int magicLevel)
      : super(WeaponCategory.melee, additionalEffect, secondAdditionalEffect, damageBonus, magicLevel);
}

class RangeWeapon extends Weapon {
  RangeWeaponType type;

  @override
  String print() {
    return "${type.label} +$damageBonus (${category.label}) ${printAdditionalEffect()} ${printSecondAdditionalEffect()}\n${super.print()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.arrow_flights;
  }

  @override
  Color? getIconColor() {
    return Colors.red;
  }

  RangeWeapon(this.type, WeaponAdditionalEffect? additionalEffect, WeaponAdditionalEffect? secondAdditionalEffect, int damageBonus, int magicLevel)
      : super(WeaponCategory.range, additionalEffect, secondAdditionalEffect, damageBonus, magicLevel);
}

class MagicScepter extends Weapon {
  MagicScepterType type;

  @override
  String print() {
    return "${category.label} (${type.label}) ${printAdditionalEffect()} ${printSecondAdditionalEffect()}\n${super.print()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.crystal_wand;
  }

  @override
  Color? getIconColor() {
    return Colors.blue;
  }

  MagicScepter(this.type, WeaponAdditionalEffect? additionalEffect, WeaponAdditionalEffect? secondAdditionalEffect, int damageBonus, int magicLevel)
      : super(WeaponCategory.magicScepter, additionalEffect, secondAdditionalEffect, damageBonus, magicLevel);
}

enum WeaponCategory {
  melee(1, "Arme de contact"),
  range(4, "Arme à distance"),
  magicScepter(6, "Sceptre de magie");

  const WeaponCategory(this.score, this.label);

  final int score;
  final String label;
  static int dice = 6;
}

enum WeaponAdditionalEffect {
  sharpened(1, "Affûtée"),
  scourgeOfTheUndead(3, "Fléau des morts"),
  scourgeOfDragons(4, "Fléau des dragons"),
  scourgeOfGiants(5, "Fléau des géants"),
  scourgeOfGoblinkind(6, "Fléau des goblinoïdes"),
  scourgeOfDemons(7, "Fléau des démons"),
  fire(8, "Feu"),
  cold(9, "Froid"),
  lightning(10, "Foudre"),
  doubleSpecialEffect(11, "Tirez deux propriétés, doublez son effet ou spécial*");

  const WeaponAdditionalEffect(this.score, this.label);

  final int score;
  final String label;
  static int dice = 12;
  static int secondDice = 10;
}

enum MeleeWeaponType {
  ovenMittsBareHands(1, "Maniques (mains nues)"),
  stick(2, "Bâton"),
  dagger(3, "Dague"),
  bastardSword(5, "Épée bâtarde"),
  shortSword(6, "Épée courte"),
  longSword(8, "Épée longue"),
  oneHandedAxe(11, "Hache à une main"),
  twoHandedSword(12, "Épée à 2 mains"),
  twoHandedAxe(14, "Hache à 2 mains"),
  maceOrHammer(15, "Masse ou marteau"),
  rapier(17, "Rapière"),
  broadswordOrKatana(19, "Vivelame ou Katana"),
  optionalWeapon(20, "Arme optionnelle");

  const MeleeWeaponType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 20;
}

enum RangeWeaponType {
  handCrossbow(1, "Arbalète de poing"),
  lightCrossbow(2, "Arbalète légère"),
  heavyCrossbow(4, "Arbalète lourde"),
  shortBow(6, "Arc court"),
  longBow(8, "Arc long"),
  dagger(10, "Dague"),
  sling(11, "Fronde"),
  hatchet(12, "Hachette"),
  javelin(13, "Javelot"),
  crossbowBolts(14, "Carreaux d’arbalète"),
  arrows(16, "Flèches"),
  slingPellets(18, "Billes de fronde"),
  optionalPowderWeapon(19, "Arme optionnelle ou à poudre");

  const RangeWeaponType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 20;
}

enum MagicScepterType {
  fire(1, "Feu"),
  lightning(3, "Foudre"),
  spirit(5, "Esprit");

  const MagicScepterType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 6;
}
