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
  int strength = 0;
  int dexterity = 0;
  int constitution = 0;
  int intelligence = 0;
  int wisdom = 0;
  int charisma = 0;
  Map<String, bool> superiorAbilities = {};

  String getFormatedNcLevel() {
    return "$ncLevel".replaceAll(".0", "");
  }

  Monster(this.id, this.name, this.creatureTokenUrl, this.type, this.environment, this.ncLevel, this.defense, this.initiative, this.healthPoint, this.archetype, this.bossType, this.strength,
      this.dexterity, this.constitution, this.intelligence, this.wisdom, this.charisma, this.superiorAbilities);
}

enum MonsterType {
  alive("Vivant", -2),
  non_living("Non Vivant", -4),
  humanoid("Humanoïde", 0),
  vegetative("Végétative", -6),
  old1("Vielles ou anciennes I", 2),
  old2("Vielles ou anciennes II", 3),
  old3("Vielles ou anciennes III", 4);

  const MonsterType(this.label, this.treasureModifier);

  final String label;
  final int treasureModifier;

  static MonsterType fromName(String? nameString) {
    return MonsterType.values.firstWhere((element) => element.name == nameString, orElse: () => MonsterType.alive);
  }

  static MonsterType fromModifier(int? modifier) {
    return MonsterType.values.firstWhere((element) => element.treasureModifier == modifier, orElse: () => MonsterType.humanoid);
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
