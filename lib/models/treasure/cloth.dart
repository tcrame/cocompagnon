import 'package:cocompagnon/models/treasure/treasure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class Stuff extends MagicItem {
  int magicLevel;

  @override
  String print() {
    return "Niveau de magie : $magicLevel";
  }

  Stuff(this.magicLevel);
}

class Armor extends Stuff {
  ArmorType type;
  ArmorAdditionalEffect? additionalEffect;
  ArmorAdditionalEffect? secondAdditionalEffect;
  int bonusDef;

  int getTotalDef() {
    return bonusDef + type.defense;
  }

  String printTotalDef() {
    return getTotalDef().toString();
  }

  String printAdditionalEffect() {
    return additionalEffect != null ? "de ${additionalEffect!.label}" : "";
  }

  String printSecondAdditionalEffect() {
    return secondAdditionalEffect != null ? "et de ${secondAdditionalEffect!.label}" : "";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.vest;
  }

  @override
  Color? getIconColor() {
    return Colors.grey;
  }

  @override
  String print() {
    return "${type.label} +$bonusDef (${getTotalDef()} DEF) ${printAdditionalEffect()} ${printSecondAdditionalEffect()} \n${super.print()}";
  }

  Armor(this.type, this.additionalEffect, this.secondAdditionalEffect, this.bonusDef, super.magicLevel);
}

class PowerItem extends Stuff {
  List<Skill> skills;

  @override
  String print() {
    return "Objet de pouvoir :${printSkills()}\n${super.print()}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.aura;
  }

  @override
  Color? getIconColor() {
    return Colors.blue;
  }

  String printSkills() {
    String toPrint = "";

    skills.forEach((skill) {
      toPrint = "$toPrint \n * Pouvoir de ${skill.profile.label} (${skill.rank.label})";
    });

    return toPrint;
  }

  PowerItem(this.skills, super.magicLevel);
}

class Skill {
  PowerItemRank rank;
  ProfileType profile;

  Skill(this.rank, this.profile);
}

class CaracItem extends Stuff {
  CaracType caracType;

  int getValue() {
    return magicLevel - 1;
  }

  @override
  IconData getIcon() {
    return RpgAwesome.gem_pendant;
  }

  @override
  Color? getIconColor() {
    return Colors.purple;
  }

  @override
  String print() {
    return "Objet de puissance +${getValue()} ${caracType.label}\n${super.print()}";
  }

  CaracItem(this.caracType, super.magicLevel);
}

enum ArmorAdditionalEffect {
  freeAction(1, "Action libre"),
  minorOrMajorDefense(2, "Défense mineure ou majeure"),
  swimming(3, "Natation"),
  shadow(4, "Ombre"),
  protection(5, "Protection"),
  magicResistance(6, "Résistance à la magie"),
  fireResistance(7, "Résistance au feu"),
  coldResistance(8, "Résistance au froid"),
  electricityResistance(9, "Résistance à l’électricité"),
  acidResistance(10, "Résistance à l’acide"),
  doubleSpecialEffect(11, "Tirez deux propriétés, doublez son effet ou spécial*");

  const ArmorAdditionalEffect(this.score, this.label);

  final int score;
  final String label;
  static int dice = 12;
  static int secondDice = 10;
}

enum ArmorType {
  protectionRing(1, "Anneau de protection", 0),
  protectionCape(2, "Cape de protection", 0),
  defenseBracelets(3, "Bracelets de défense", 0),
  mageRobe(5, "Robe de mage", 0),
  quiltedFabric(6, "Tissus matelassé", 1),
  leather(7, "Cuir", 2),
  reinforcedLeather(8, "Cuir renforcé", 3),
  chainmailShirt(9, "Chemise de maille", 4),
  chainmailHauberk(12, "Cotte de maille", 5),
  halfPlate(14, "Demi-plaque", 6),
  fullPlate(16, "Plaque complète", 8),
  smallShield(17, "Petit bouclier", 1),
  largeShield(19, "Grand bouclier", 2);

  const ArmorType(this.score, this.label, this.defense);

  final int score;
  final String label;
  final int defense;
  static int dice = 20;
}

enum CaracType {
  strength(1, "FOR"),
  dexterity(2, "DEX"),
  constitution(3, "CON"),
  intelligence(4, "INT"),
  wisdom(5, "SAG"),
  charisma(6, "CHA");

  const CaracType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 6;
}

enum PowerItemRank {
  rank1(1, "Rang 1", 1),
  rank2(3, "Rang 2", 2),
  rank3(5, "Rang 3", 3),
  rank4(7, "Rang 4", 4),
  rank5(8, "Rang 5", 5);

  const PowerItemRank(this.score, this.label, this.rank);

  final int score;
  final String label;
  final int rank;
  static int dice = 8;
}

enum ProfileType {
  musketeer(1, "Arquebusier"),
  bard(2, "Barde"),
  barbarian(3, "Barbare"),
  knight(4, "Chevalier"),
  druid(5, "Druide"),
  sorcerer(7, "Ensorceleur"),
  spellforge(9, "Forgesort"),
  warrior(11, "Guerrier"),
  magician(12, "Magicien"),
  monk(14, "Moine"),
  necromancer(15, "Nécromancien"),
  priest(17, "Prêtre"),
  ranger(19, "Rôdeur"),
  rogue(20, "Voleur");

  const ProfileType(this.score, this.label);

  final int score;
  final String label;
  static int dice = 20;

  static ProfileType fromName(String name) {
    return ProfileType.values.firstWhere((element) => element.name == name);
  }
}
