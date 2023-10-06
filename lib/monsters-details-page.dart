import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocompagnon/combat-page.dart';
import 'package:cocompagnon/monster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'about-page.dart';
import 'monsters-details-page-controller.dart';
import 'monsters-page.dart';

class MonstersDetailPage extends StatelessWidget {
  final Monster monster;

  const MonstersDetailPage({super.key, required this.monster});

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider<MonstersPageDetailsController>(create: (BuildContext context) {
      var monsterPageDetailsController = MonstersPageDetailsController();
      monsterPageDetailsController.loadMonsterDetails(monster.id);
      return monsterPageDetailsController;
    }, builder: (context, child) {
      final controller = context.watch<MonstersPageDetailsController>();
      return StatefulBuilder(
          builder: (context, setStateSB) => Scaffold(
                appBar: AppBar(
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white, // Change Custom Drawer Icon Color
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                      );
                    },
                  ),
                  backgroundColor: Colors.grey.shade900,
                  title: Text(monster.name, style: const TextStyle(fontSize: 17, color: Colors.white)),
                  actions: [
                    Builder(builder: (context) {
                      return IconButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ));
                    }),
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: 130,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.red.shade900,
                          ),
                          child: Text('Menu',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                                fontSize: 40,
                              )),
                        ),
                      ),
                      ListTile(
                        title: const Text('Tracker de combat'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CombatPage()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Bestiaire'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MonstersPage()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('A propos'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AboutPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/vintage-grunge-paper-background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: controller.monsterDetails != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView(children: <Widget>[
                                    Visibility(
                                      visible: controller.monsterDetails != null && controller.monsterDetails?.urlImage != null,
                                      child: CachedNetworkImage(
                                        imageUrl: controller.monsterDetails!.urlImage,
                                        progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => Image.network(
                                          controller.monsterDetails!.urlImage,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                            child: Text(
                                              'NC: ${monster.getFormatedNcLevel()}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Visibility(
                                            visible: controller.monsterDetails?.monsterFamilly.id != 0,
                                            child: Container(
                                              color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: Text(
                                                'Famille de créature: ${controller.monsterDetails!.monsterFamilly.label}',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Text(
                                              'Type de boss: ${monster.bossType.label}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Visibility(
                                            visible: controller.monsterDetails?.bossRank != 0,
                                            child: Container(
                                              color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                              child: Text(
                                                'Rang de boss : ${controller.monsterDetails!.bossRank}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Visibility(
                                      visible: controller.monsterDetails?.description != "",
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        child: Html(
                                          data: controller.monsterDetails!.description,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.monsterDetails?.appearance != "",
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        child: Html(
                                          data: controller.monsterDetails!.appearance,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.monsterDetails?.comments != "",
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        child: Html(
                                          data: controller.monsterDetails!.comments,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      'Statistiques',
                                      style: TextStyle(fontSize: 25, color: Colors.black),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 70,
                                                  child: Row(
                                                    children: [
                                                      const Text("DEF"),
                                                      const Icon(
                                                        Icons.security,
                                                        color: Colors.blueAccent,
                                                      ),
                                                      Text('${monster.defense}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 70,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "PV",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      ),
                                                      Text('${monster.healthPoint}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 70,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Init",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        Icons.trending_up_outlined,
                                                        color: Colors.green,
                                                      ),
                                                      Text('${monster.initiative}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 20,
                                          thickness: 2,
                                          endIndent: 0,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 75,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "FOR",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        RpgAwesome.muscle_up,
                                                        color: Colors.red,
                                                      ),
                                                      Text('${controller.printCaracMod(monster.strength)}${controller.showSuperiorAbility("str", monster)}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 75,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "DEX",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        RpgAwesome.feather_wing,
                                                        color: Colors.white,
                                                      ),
                                                      Text('${controller.printCaracMod(monster.dexterity)}${controller.showSuperiorAbility("dex", monster)}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "CON",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        RpgAwesome.vest,
                                                        color: Colors.blueGrey,
                                                      ),
                                                      Text('${controller.printCaracMod(monster.constitution)}${controller.showSuperiorAbility("con", monster)}')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 20,
                                          thickness: 2,
                                          endIndent: 0,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 75,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "INT",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        size: 20,
                                                        FontAwesome5.brain,
                                                        color: Colors.pinkAccent,
                                                      ),
                                                      Text(" ${controller.printCaracMod(monster.intelligence)}${controller.showSuperiorAbility('int', monster)}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "SAG",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        FontAwesome5.eye,
                                                        color: Colors.blueGrey,
                                                      ),
                                                      Text(" ${controller.printCaracMod(monster.wisdom)}${controller.showSuperiorAbility('wis', monster)}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "CHA",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Icon(
                                                        RpgAwesome.speech_bubbles,
                                                        color: Colors.grey,
                                                      ),
                                                      Text("${controller.printCaracMod(monster.charisma)}${controller.showSuperiorAbility('cha', monster)}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      'Characteristiques',
                                      style: TextStyle(fontSize: 25, color: Colors.black),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                flex: 6,
                                                child: Text("Catégorie de créature"),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text('${controller.monsterDetails?.category}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 20,
                                          thickness: 2,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                flex: 6,
                                                child: Text(
                                                  "Millieu naturel",
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text('${controller.monsterDetails?.environment}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 20,
                                          thickness: 2,
                                          endIndent: 0,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                flex: 6,
                                                child: Text(
                                                  "Archétype",
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text('${controller.monsterDetails?.archetype}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          height: 20,
                                          thickness: 2,
                                          endIndent: 0,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                flex: 6,
                                                child: Text(
                                                  "Taille",
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text('${controller.monsterDetails?.size}'),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                    ),
                                    Visibility(visible: controller.hasAttacks(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                      visible: controller.hasAttacks(),
                                      child: const Text(
                                        'Attaque(s)',
                                        style: TextStyle(fontSize: 25, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Visibility(visible: controller.hasAttacks(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                      visible: controller.hasAttacks(),
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Column(children: controller.monsterDetails!.attacks.map((attack) => Html(data: attack != null ? attack!.label : "")).toList()),
                                      ),
                                    ),
                                    Visibility(visible: controller.hasAttacks(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                        visible: controller.hasSpecialCapabalities(),
                                        child: const Text(
                                          'Capacité(s) spéciales',
                                          style: TextStyle(fontSize: 25, color: Colors.black),
                                          textAlign: TextAlign.left,
                                        )),
                                    Visibility(visible: controller.hasPath(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                      visible: controller.hasSpecialCapabalities(),
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Column(children: controller.monsterDetails!.specialCapabilities.where((element) => element != null).map((path) => Html(data: path)).toList()),
                                      ),
                                    ),
                                    Visibility(visible: controller.hasSpecialCapabalities(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                        visible: controller.monsterDetails != null && controller.monsterDetails!.profile != null,
                                        child: const Text(
                                          'Profil',
                                          style: TextStyle(fontSize: 25, color: Colors.black),
                                          textAlign: TextAlign.left,
                                        )),
                                    Visibility(visible: controller.monsterDetails != null && controller.monsterDetails!.profile != null, child: const SizedBox(height: 10.0)),
                                    Visibility(
                                      visible: controller.monsterDetails != null && controller.monsterDetails!.profile != null && controller.monsterDetails!.profile!.label != null,
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Column(children: [
                                          SizedBox(
                                              width: 500,
                                              child: Text(
                                                "Profil : ${controller.monsterDetails!.profile != null ? controller.monsterDetails!.profile!.label : ''}",
                                                textAlign: TextAlign.left,
                                              )),
                                          SizedBox(
                                              width: 500,
                                              child: Text(
                                                "Niveau de profil : ${controller.monsterDetails!.profile != null ? controller.monsterDetails!.profile!.level : ''}",
                                                textAlign: TextAlign.left,
                                              )),
                                        ]),
                                      ),
                                    ),
                                    Visibility(visible: controller.monsterDetails != null && controller.monsterDetails!.profile != null, child: const SizedBox(height: 10.0)),
                                    Visibility(
                                        visible: controller.hasPath(),
                                        child: const Text(
                                          'Voie(s)',
                                          style: TextStyle(fontSize: 25, color: Colors.black),
                                          textAlign: TextAlign.left,
                                        )),
                                    Visibility(visible: controller.hasPath(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                      visible: controller.hasPath(),
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Column(children: controller.monsterDetails!.paths.where((element) => element != null).map((path) => Html(data: path)).toList()),
                                      ),
                                    ),
                                    Visibility(visible: controller.hasCapacities(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                        visible: controller.hasCapacities(),
                                        child: const Text(
                                          'Capacité(s)',
                                          style: TextStyle(fontSize: 25, color: Colors.black),
                                          textAlign: TextAlign.left,
                                        )),
                                    Visibility(visible: controller.hasCapacities(), child: const SizedBox(height: 10.0)),
                                    Visibility(
                                      visible: controller.hasCapacities(),
                                      child: Container(
                                        color: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        child: ExpansionPanelList(
                                            dividerColor: Colors.grey,
                                            expansionCallback: (int index, bool isExpanded) {
                                              setStateSB(() {
                                                controller.changeCapabilitiesPanelState(index);
                                              });
                                            },
                                            children: controller.monsterDetails!.capabilities
                                                .where((capability) => capability != null)
                                                .map(
                                                  (capability) => ExpansionPanel(
                                                    backgroundColor: const Color.fromARGB(150, 0xee, 0xee, 0xee),
                                                    isExpanded: capability!.isOpen,
                                                    headerBuilder: (context, isOpen) {
                                                      return Padding(
                                                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                                        child: Text(
                                                          "${capability.rank}. ${capability.label}${controller.showLimited(capability)}${controller.showMagical(capability)}",
                                                          style: const TextStyle(fontSize: 18, color: Colors.black),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      );
                                                    },
                                                    body: Padding(
                                                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                                      child: Text("${capability.description}"),
                                                    ),
                                                  ),
                                                )
                                                .toList()),
                                      ),
                                    ),
                                    Visibility(visible: controller.hasCapacities(), child: const SizedBox(height: 50.0)),
                                  ]),
                                ),
                              ],
                            ),
                          )
                        : const Text("Loading...")),
              ));
    });
  }
}
