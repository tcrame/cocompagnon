class Monster {
  int id;
  String name;
  String creatureTokenUrl;
  MonsterType type;
  MonsterEnvironment environment;
  MonsterArchetype archetype;
  MonsterBossType bossType;
  double ncLevel;
  int defense;
  int initiative;
  int healthPoint;

  String getFormatedNcLevel() {
    return "$ncLevel".replaceAll(".0", "");
  }

  Monster(this.id, this.name, this.creatureTokenUrl, this.type, this.environment, this.ncLevel, this.defense, this.initiative, this.healthPoint, this.archetype, this.bossType);
}

enum MonsterType {
  alive("Vivant"),
  non_living("Non Vivant"),
  humanoid("Humanoïde"),
  vegetative("Végétative");

  const MonsterType(this.label);

  final String label;

  static MonsterType fromName(String? nameString) {
    return MonsterType.values.firstWhere((element) => element.name == nameString, orElse: () => MonsterType.alive);
  }
}

enum MonsterEnvironment {
  aquatic("Aquatique"),
  forest("Forêt"),
  swamp("Marécage"),
  mountain("Montagne"),
  plain("Plaine"),
  underground("Souterrain"),
  special("special");

  const MonsterEnvironment(this.label);

  final String label;

  static MonsterEnvironment fromName(String? nameString) {
    return MonsterEnvironment.values.firstWhere((element) => element.name == nameString, orElse: () => MonsterEnvironment.special);
  }
}

enum MonsterArchetype {
  inferior("Inférieur"),
  fast("Rapide"),
  standard("Standard"),
  powerful("Puissant");

  const MonsterArchetype(this.label);

  final String label;

  static MonsterArchetype fromName(String? nameString) {
    return MonsterArchetype.values.firstWhere((element) => element.name == nameString, orElse: () => MonsterArchetype.standard);
  }
}

enum MonsterBossType {
  none("Aucun"),
  standard("Standard"),
  berserk("Berserk"),
  fast("Rapide"),
  resistant("Résistant"),
  powerful("Puissant");

  const MonsterBossType(this.label);

  final String label;

  static MonsterBossType fromName(String? nameString) {
    return MonsterBossType.values.firstWhere((element) => element.name == nameString, orElse: () => MonsterBossType.none);
  }
}

enum MonsterOrderBy {
  alphabetic(1, "A -> Z"),
  reverseAlphabetic(2, "Z -> A"),
  minNC(3, "NC le plus haut"),
  maxNc(4, "NC le plus bas");

  const MonsterOrderBy(this.code, this.label);

  final String label;
  final int code;

}
