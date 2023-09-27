import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocompagnon/combat-page.dart';
import 'package:cocompagnon/monsters-details-page.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'about-page.dart';
import 'monster.dart';
import 'monsters-page-controller.dart';

class MonstersPage extends StatelessWidget {
  const MonstersPage({super.key});

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider<MonstersPageController>(create: (BuildContext context) {
      var monsterPageController = MonstersPageController();
      monsterPageController.loadAllCreaturesLocally();
      return monsterPageController;
    }, builder: (context, child) {
      final controller = context.watch<MonstersPageController>();
      return Scaffold(
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
          title: const Text('Bestiaire by CO-DRS', style: TextStyle(fontSize: 17, color: Colors.white)),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(
                    Icons.filter_alt,
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
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 130,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Filtres',
                      style: GoogleFonts.kalam(
                        color: Colors.white,
                        fontSize: 40,
                      )),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Type de créature'),
                    const SizedBox(height: 5.0),
                    Wrap(
                      spacing: 5.0,
                      children: MonsterType.values.map((MonsterType monsterType) {
                        var selectedFilter = controller.monsterTypeFilters.contains(monsterType);
                        return FilterChip(
                          backgroundColor: Colors.white,
                          selectedColor: Colors.green,
                          label: Text(
                            monsterType.label,
                            style: TextStyle(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: selectedFilter,
                          onSelected: (bool selected) {
                            controller.removeOrAddMonsterTypeFilterSelection(selectedFilter, monsterType);
                          },
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const Text('Millieu naturel'),
                    const SizedBox(height: 5.0),
                    Wrap(
                      spacing: 5.0,
                      children: MonsterEnvironment.values.map((MonsterEnvironment monsterEnvironment) {
                        var selectedFilter = controller.monsterEnvironmentFilters.contains(monsterEnvironment);
                        return FilterChip(
                          backgroundColor: Colors.white,
                          selectedColor: Colors.green,
                          label: Text(
                            monsterEnvironment.label,
                            style: TextStyle(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: selectedFilter,
                          onSelected: (bool selected) {
                            controller.removeOrAddMonsterEnvironmentFilterSelection(selectedFilter, monsterEnvironment);
                          },
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const Text('Archetype'),
                    const SizedBox(height: 5.0),
                    Wrap(
                      spacing: 5.0,
                      children: MonsterArchetype.values.map((MonsterArchetype monsterArchetype) {
                        var selectedFilter = controller.monsterArchetypeFilters.contains(monsterArchetype);
                        return FilterChip(
                          backgroundColor: Colors.white,
                          selectedColor: Colors.green,
                          label: Text(
                            monsterArchetype.label,
                            style: TextStyle(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: selectedFilter,
                          onSelected: (bool selected) {
                            controller.removeOrAddMonsterArchetypeFilterSelection(selectedFilter, monsterArchetype);
                          },
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const Text('Type de boss'),
                    const SizedBox(height: 5.0),
                    Wrap(
                      spacing: 5.0,
                      children: MonsterBossType.values.map((MonsterBossType monsterBossType) {
                        var selectedFilter = controller.monsterBossTypeFilters.contains(monsterBossType);
                        return FilterChip(
                          backgroundColor: Colors.white,
                          selectedColor: Colors.green,
                          label: Text(
                            monsterBossType.label,
                            style: TextStyle(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selectedFilter == true ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: selectedFilter,
                          onSelected: (bool selected) {
                            controller.removeOrAddMonsterBossTypeFilterSelection(selectedFilter, monsterBossType);
                          },
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30.0),
                    DropdownMenu<MonsterOrderBy>(
                      initialSelection: MonsterOrderBy.alphabetic,
                      controller: controller.orderByController,
                      label: const Text('Trier par'),
                      dropdownMenuEntries: MonsterOrderBy.values.map((orderBy) => DropdownMenuEntry<MonsterOrderBy>(value: orderBy, label: orderBy.label, enabled: true)).toList(),
                      onSelected: (MonsterOrderBy? orderBy) {
                        controller.changeSortingDirection(orderBy ?? MonsterOrderBy.alphabetic);
                      },
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              )
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
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  TextField(
                    onChanged: (value) => controller.runFilter(value),
                    decoration: const InputDecoration(
                      labelText: 'Recherche',
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIconColor: Colors.black,
                      suffixIcon: Icon(Icons.search),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: controller.filteredMonsters.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              itemCount: controller.filteredMonsters.length,
                              itemBuilder: (BuildContext context, int index) {
                                final monster = controller.filteredMonsters[index];
                                return IntrinsicWidth(
                                    child: Container(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 1),
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage("assets/images/parchment.png"),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        height: 107,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 9,
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: IntrinsicWidth(
                                                      child: Container(
                                                          child: Column(children: [
                                                    Container(
                                                        padding: const EdgeInsets.fromLTRB(10, 3, 10, 1),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                          CachedNetworkImage(
                                                            height: 30,
                                                            width: 30,
                                                            imageUrl: monster.creatureTokenUrl,
                                                            progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                                          ),
                                                          Text(
                                                            monster.name,
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' - ${monster.type.label}',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ])),
                                                    Container(
                                                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                          const Icon(
                                                            Icons.security,
                                                            color: Colors.blueAccent,
                                                          ),
                                                          Text(
                                                            '${monster.defense}',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            '${monster.healthPoint}',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.trending_up_outlined,
                                                            color: Colors.green,
                                                          ),
                                                          Text(
                                                            '${monster.initiative}',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' NC : ${monster.getFormatedNcLevel()} ',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ])),
                                                    Container(
                                                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                          const Icon(
                                                            RpgAwesome.muscle_up,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            '${controller.printCaracMod(monster.strength)}${controller.showSuperiorAbility("str", monster)} ',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            RpgAwesome.feather_wing,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            '${controller.printCaracMod(monster.dexterity)}${controller.showSuperiorAbility("dex", monster)} ',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            RpgAwesome.vest,
                                                            color: Colors.blueGrey,
                                                          ),
                                                          Text(
                                                            '${controller.printCaracMod(monster.constitution)}${controller.showSuperiorAbility("con", monster)} ',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            size: 20,
                                                            FontAwesome5.brain,
                                                            color: Colors.pinkAccent,
                                                          ),
                                                          Text(
                                                            ' ${controller.printCaracMod(monster.intelligence)}${controller.showSuperiorAbility("int", monster)} ',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            FontAwesome5.eye,
                                                            color: Colors.blueGrey,
                                                          ),
                                                          Text(
                                                            ' ${controller.printCaracMod(monster.wisdom)}${controller.showSuperiorAbility("wis", monster)} ',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            RpgAwesome.speech_bubbles,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                            '${controller.printCaracMod(monster.charisma)}${controller.showSuperiorAbility("cha", monster)}',
                                                            style: GoogleFonts.kalam(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ])),
                                                  ])))),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: PopupMenuButton<int>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      value: 1,
                                                      child: ElevatedButton.icon(
                                                        icon: const Icon(Icons.add),
                                                        label: const Text('Ajouter dans le tracker de combat'),
                                                        onPressed: () {
                                                          controller.addMonsterInTracker(monster);
                                                          Navigator.pop(context);
                                                        },
                                                      )),
                                                  PopupMenuItem(
                                                      value: 2,
                                                      child: ElevatedButton.icon(
                                                        icon: const Icon(Icons.zoom_in),
                                                        label: const Text('Voir détails'),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => MonstersDetailPage(monster: monster, monsterJson: controller.allMonstersJson[monster.id.toString()])),
                                                          );
                                                        },
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )));
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                            )
                          : const Text(
                              'Pas de resultats',
                              style: TextStyle(fontSize: 24),
                            ))
                ]))),
      );
    });
  }
}
