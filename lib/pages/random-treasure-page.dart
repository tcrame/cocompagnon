import 'package:cocompagnon/controllers/random-treasure-controller.dart';
import 'package:cocompagnon/models/monster.dart';
import 'package:cocompagnon/pages/widgets/menu-drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:provider/provider.dart';

class RandomTreasurePage extends StatelessWidget {
  const RandomTreasurePage({super.key});

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider<RandomTreasureController>(create: (BuildContext context) {
      var randomTreasureController = RandomTreasureController();
      return randomTreasureController;
    }, builder: (context, child) {
      final controller = context.watch<RandomTreasureController>();
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
                  title: const Text('Générateur de trésor aléatoire', style: TextStyle(fontSize: 17, color: Colors.white)),
                ),
                drawer: const MenuDrawer(),
                body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/vintage-grunge-paper-background.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(children: [
                          Row(
                            children: [
                              const Expanded(flex: 8, child: Text("Categorie de la créature :")),
                              Expanded(
                                flex: 8,
                                child: DropdownButton<String>(
                                  value: controller.monsterType.name,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? value) {
                                    setStateSB(() {
                                      controller.updateMonsterCategory(value);
                                    });
                                  },
                                  items: MonsterType.values.map<DropdownMenuItem<String>>((MonsterType monsterType) {
                                    return DropdownMenuItem<String>(
                                        value: monsterType.name,
                                        child: Row(children: <Widget>[
                                          Text(monsterType.label),
                                        ]));
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              const Expanded(flex: 8, child: Text("Nc de la créature :")),
                              Expanded(
                                flex: 8,
                                child: TextField(
                                  controller: controller.monsterNcController,
                                  onChanged: (String? value) {
                                    setStateSB(() {
                                      controller.calculateTreasureLevel();
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(color: Colors.black),
                                    suffixIconColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Expanded(flex: 8, child: Text("Mod d'INT de la créature :")),
                              Expanded(
                                flex: 8,
                                child: TextField(
                                  controller: controller.monsterModInt,
                                  onChanged: (String? value) {
                                    setStateSB(() {
                                      controller.calculateTreasureLevel();
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(color: Colors.black),
                                    suffixIconColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Expanded(flex: 8, child: Text("Niveau de trésor :")),
                              Expanded(
                                  flex: 8,
                                  child: Text(
                                    controller.printTreasureLevel(),
                                    style: const TextStyle(fontSize: 17, color: Colors.white),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: ElevatedButton.icon(
                            icon: const Icon(RpgAwesome.gold_bar),
                            label: const Text('Générer trésor'),
                            onPressed: () {
                              controller.generateRandomTreasure(context);
                            },
                          )),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: controller.treasures.isNotEmpty
                                  ? ListView.separated(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                itemCount: controller.treasures.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final treasure = controller.treasures[index];
                                  return IntrinsicWidth(
                                      child: Container(
                                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/parchment.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          height: controller.calculeTreasureHeight(treasure),
                                          child: Row(
                                            children: [
                                              Expanded(flex: 1, child: Icon(treasure.getIcon(), color: treasure.getIconColor())),
                                              const SizedBox(width: 5,),
                                              Expanded(flex: 12, child: Text(treasure.print(), overflow: TextOverflow.clip,)),
                                            ],
                                          )));
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              )
                                  : const Text(
                                'Pas de trésor',
                                style: TextStyle(fontSize: 24),
                              ))
                        ]))),
              ));
    });
  }
}
