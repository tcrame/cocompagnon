import 'package:cocompagnon/models/treasure/treasure.dart';
import 'package:cocompagnon/utils/dice-utils.dart';
import 'package:cocompagnon/utils/shared-preferences-utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class Scroll extends SkillItem {
  @override
  String print() {
    return "Parchemin de ${getSkill()}\n${getProfile()} ${path.label} Rang $rank";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.scroll_unfurled;
  }

  @override
  Color? getIconColor() {
    return Colors.brown[400];
  }

  Scroll(super.path, super.rank);
}

class MagicWand extends SkillItem {
  int nbCharge = rollDices(2, 20);

  @override
  String print() {
    return "Baguette de ${getSkill()}\n${getProfile()} ${path.label} Rang $rank\n$nbCharge charges";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.fairy_wand;
  }

  @override
  Color? getIconColor() {
    return Colors.yellowAccent;
  }

  MagicWand(super.path, super.rank);
}

class SkillItem extends MagicItem {
  ItemPath path;
  int rank;

  String getSkill() {
    return SharedPreferencesUtils.getCapacity(path, rank).name;
  }

  String getProfile() {
    return ScrollProfile.fromCode(path.profileCode).label;
  }

  SkillItem(this.path, this.rank);
}

enum ScrollProfile {
  sorcerer("Ensorceleur", 1),
  magician("Magicien", 2),
  necromancer("Nécromancien", 3),
  priest("Prêtre", 4),
  druid("Druide", 5);

  const ScrollProfile(this.label, this.code);

  final String label;
  final int code;

  static ScrollProfile fromCode(int code) {
    return ScrollProfile.values.firstWhere((element) => element.code == code);
  }
}

enum MinorSkillItemRank {
  rank1(1, "Rang 1", 1),
  rank2(4, "Rang 2", 2),
  rank3(6, "Rang 3", 3);

  const MinorSkillItemRank(this.score, this.label, this.rank);

  final int score;
  final String label;
  final int rank;
  static int dice = 6;
}

enum MediumSkillItemRank {
  rank1(1, "Rang 3", 3),
  rank2(3, "Rang 4", 4),
  rank3(5, "Rang 5", 5);

  const MediumSkillItemRank(this.score, this.label, this.rank);

  final int score;
  final String label;
  final int rank;
  static int dice = 6;
}
