class Monster {
  int id;
  String name;
  String creatureTokenUrl;
  MonsterType type;
  MonsterEnvironment environment;
  double ncLevel;
  int defense;
  int initiative;
  int healthPoint;

  String getFormatedNcLevel() {
    return "$ncLevel".replaceAll(".0", "");
  }

  Monster(this.id, this.name, this.creatureTokenUrl, this.type, this.environment, this.ncLevel, this.defense, this.initiative, this.healthPoint);
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
