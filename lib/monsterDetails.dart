class MonsterDetails {
  String description;
  String appearance;
  String comments;
  String size;
  String urlImage;
  String category;
  String environment;
  String archetype;
  int bossRank;
  MonsterFamilly monsterFamilly;

  List<MonsterAttack?> attacks;
  List<String?> paths;
  List<MonsterCapability?> capabilities;
  List<String?> specialCapabilities;
  MonsterProfile? profile;

  MonsterDetails(this.description, this.appearance, this.comments, this.size, this.urlImage, this.category, this.environment, this.archetype, this.bossRank, this.monsterFamilly, this.attacks,
      this.paths, this.capabilities, this.specialCapabilities, this.profile);
}

class MonsterFamilly {
  String label;
  int id;

  MonsterFamilly(this.label, this.id);
}

class MonsterProfile {
  String? label;
  int? level;

  MonsterProfile(this.label, this.level);
}

class MonsterAttack {
  String? label;
  String? name;
  String? test;
  String? dm;
  String? special;
  String? reach;

  MonsterAttack(this.label, this.name, this.test, this.dm, this.special, this.reach);
}

class MonsterCapability {
  String? label;
  int? rank;
  bool? isLimited;
  bool? isMagical;
  String? description;
  String? paths;
  bool isOpen = false;

  MonsterCapability(this.label, this.rank, this.isLimited, this.isMagical, this.description, this.paths, this.isOpen);
}