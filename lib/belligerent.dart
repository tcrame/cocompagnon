import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@JsonSerializable()
class Belligerent {
  String name;
  String uuid;
  int defense;
  int initiative;
  int currentInitiative;
  int maxPv;
  BelligerentType? belligerentType;
  int currentPv;
  List<BelligerentDebuff> debuffs = <BelligerentDebuff>[];

  Belligerent(
      {required this.name,
      required this.defense,
      required this.initiative,
      required this.currentPv,
      required this.maxPv,
      this.belligerentType,
      required this.currentInitiative,
      required this.uuid,
      required this.debuffs});

  double getRatioOfPv() {
    return currentPv / maxPv;
  }

  MaterialColor getBarColor() {
    var ratioOfPv = getRatioOfPv();
    if (ratioOfPv >= 0 && ratioOfPv < 0.3) {
      return Colors.red;
    } else if (ratioOfPv >= 0.3 && ratioOfPv < 0.6) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  recalculateInitiative(bool isInitiativeOptionalRuleActivated) {
    if (isInitiativeOptionalRuleActivated) {
      currentInitiative = initiative + Random().nextInt(6) + 1;
    } else {
      currentInitiative = initiative;
    }
  }

  void recalculateDebuffs() {
    for (var debuff in debuffs) {
      debuff.durationInTurn--;
    }
    debuffs.removeWhere((debuff) => debuff.durationInTurn <= 0);
  }

  /// Connect the generated [_$BelligerentFromJson] function to the `fromJson`
  /// factory.
  factory Belligerent.fromJson(Map<String, dynamic> json) => _$BelligerentFromJson(json);

  /// Connect the generated [_$BelligerentToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BelligerentToJson(this);
}

Belligerent _$BelligerentFromJson(Map<String, dynamic> json) => Belligerent(
      name: json['name'] as String,
      uuid: json['uuid'] as String,
      defense: json['defense'] as int,
      initiative: json['initiative'] as int,
      currentInitiative: json['currentInitiative'] as int,
      maxPv: json['maxPv'] as int,
      currentPv: json['currentPv'] as int,
      belligerentType: BelligerentType.fromCode(json['belligerentType'] as int),
      debuffs: List<BelligerentDebuff>.from((json['debuffs'] as Iterable).map<BelligerentDebuff>((dynamic e) => BelligerentDebuff.fromJson(e))),
    );

Map<String, dynamic> _$BelligerentToJson(Belligerent instance) => <String, dynamic>{
      'name': instance.name,
      'uuid': instance.uuid,
      'defense': instance.defense,
      'initiative': instance.initiative,
      'currentInitiative': instance.currentInitiative,
      'maxPv': instance.maxPv,
      'currentPv': instance.currentPv,
      'belligerentType': instance.belligerentType?.code,
      'debuffs': instance.debuffs.map((e) => e.toJson()).toList()
    };

@JsonSerializable()
class BelligerentDebuff {
  BelligerentDebuffType? type;
  String description;
  int durationInTurn;

  BelligerentDebuff({required this.type, required this.description, required this.durationInTurn});

  /// Connect the generated [_$BelligerentFromJson] function to the `fromJson`
  /// factory.
  factory BelligerentDebuff.fromJson(Map<String, dynamic> json) => _$BelligerentDebuffFromJson(json);

  /// Connect the generated [_$BelligerentToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BelligerentDebuffToJson(this);
}

BelligerentDebuff _$BelligerentDebuffFromJson(Map<String, dynamic> json) => BelligerentDebuff(
      type: BelligerentDebuffType.fromCode((json['type'] as int)),
      description: json['description'] as String,
      durationInTurn: json['durationInTurn'] as int,
    );

Map<String, dynamic> _$BelligerentDebuffToJson(BelligerentDebuff instance) => <String, dynamic>{
      'type': instance.type?.code,
      'description': instance.description,
      'durationInTurn': instance.durationInTurn,
    };

@JsonEnum(valueField: 'code')
enum BelligerentType {
  ally(1),
  enemy(2);

  const BelligerentType(this.code);

  final int code;

  static BelligerentType fromCode(int code) {
    return BelligerentType.values.firstWhere((element) => element.code == code);
  }
}

@JsonEnum(valueField: 'code')
enum BelligerentDebuffType {
  blind(1, Icons.blind, "Aveuglé", "Init. -5, Att. contact -5, DEF -5, Att. dist. -10"),
  weakened(2, Icons.heart_broken, "Affaibli", "d12 pour tous les tests au lieu du d20"),
  stunned(3, Icons.ssid_chart, "Étourdi", "Aucune action possible, DEF -5"),
  rooted(4, Icons.vertical_align_bottom_sharp, "Immobilisé", "d12 pour tous les tests au lieu du d20, pas de déplacement"),
  paralyzed(5, Icons.accessible, "Paralysé", "Aucune action possible, en cas d’attaque : touché automatiquement et subit un coup critique"),
  slowed(6, Icons.slow_motion_video, "Ralenti", "Une seule action par tour (action d’attaque ou de mouvement)"),
  knockedDown(7, Icons.u_turn_right_sharp, "Renversé", "Att. -5, DEF -5, nécessite une action de mouvement pour se relever"),
  surprised(8, Icons.supervisor_account, "Surpris", "Pas d’action, DEF -5 au 1er tour de combat"),
  other(9, Icons.live_help, "Autre", "");

  final int code;
  final IconData icon;
  final String label;
  final String description;

  const BelligerentDebuffType(this.code, this.icon, this.label, this.description);

  static BelligerentDebuffType fromCode(int code) {
    return BelligerentDebuffType.values.firstWhere((element) => element.code == code);
  }
}
