import 'package:cocompagnon/models/treasure/treasure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class MoneyTreasure extends Treasure {
  CoinType coinType;
  int value;

  @override
  String print() {
    return "$value ${coinType.label}";
  }

  @override
  IconData getIcon() {
    return FontAwesome5.coins;
  }

  @override
  Color getIconColor() {
    return Colors.yellow;
  }

  MoneyTreasure(this.coinType, this.value);
}

class JewelTreasure extends Treasure {
  CoinType coinType;
  int value;

  @override
  String print() {
    return "$value ${coinType.label}";
  }

  @override
  IconData getIcon() {
    return RpgAwesome.sapphire;
  }

  @override
  Color getIconColor() {
    return Colors.green;
  }

  JewelTreasure(this.coinType, this.value);
}

enum CoinType {
  none(""),
  silver("PA"),
  gold("PO"),
  platinum("PP");

  const CoinType(this.label);

  final String label;
}
