import 'package:cocompagnon/combat-page-controller.dart';
import 'package:cocompagnon/combat-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'belligerent.dart';
import 'monster.dart';
import 'monsters-page-controller.dart';

class MonstersPage extends StatelessWidget {
  const MonstersPage({super.key});

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider<MonstersPageController>(create: (BuildContext context) {
      var monsterPageController = MonstersPageController();
      monsterPageController.loadAllCreatures();
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
          title: const Text('Bestiaire - powered by CO-DRS', style: TextStyle(fontSize: 17, color: Colors.white)),
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
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu'),
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
            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Filtres'),
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
                                        height: 80,
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: IntrinsicWidth(
                                                child: Container(
                                                    child: Column(children: [
                                                      Container(
                                                          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                            Image.network(
                                                              monster.creatureTokenUrl,
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                            Text('  ${monster.name}'),
                                                            Text(' - ${monster.type.label}'),
                                                            Text(' - NC : ${monster.getFormatedNcLevel()}'),
                                                          ])),
                                                      Container(
                                                          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                            const Icon(
                                                              Icons.security,
                                                              color: Colors.blueAccent,
                                                            ),
                                                            Text('  ${monster.defense}'),
                                                            const Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                            ),
                                                            Text('  ${monster.healthPoint}'),
                                                            const Icon(
                                                              Icons.trending_up_outlined,
                                                              color: Colors.green,
                                                            ),
                                                            Text('  ${monster.initiative}'),
                                                          ])),
                                                    ]))))));
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
