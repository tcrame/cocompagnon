import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocompagnon/controllers/combat-page-controller.dart';
import 'package:cocompagnon/pages/widgets/menu-drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/belligerent.dart';
import 'combat-page/combat-page-widgets.dart';

class CombatPage extends StatelessWidget {
  const CombatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CombatPageController>(
      create: (BuildContext context) {
        var mainPageController = CombatPageController();
        mainPageController.restoreBelligerents();
        mainPageController.restoreCurrentTurn();
        mainPageController.restoreInitiativeOptionalRuleState();
        return mainPageController;
      },
      builder: (context, child) {
        final controller = context.watch<CombatPageController>();
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
            title: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text("Tracker de combat - Tour ${controller.turn}", style: const TextStyle(fontSize: 16, color: Colors.white))),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.restart_alt),
                  onPressed: () => controller.resetTurns(),
                  color: Colors.white,
                );
              }),
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ));
              }),
            ],
          ),
          drawer: const MenuDrawer(),
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
                    child: Text('Options',
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
                      const Text("Règle optionnelle d'initiative"),
                      const SizedBox(height: 5.0),
                      Switch(
                        value: controller.isInitiativeOptionalRuleActivated,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          controller.toggleInitiativeOptionalRule(controller.isInitiativeOptionalRuleActivated);
                        },
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 90),
                itemCount: controller.belligerents.length,
                itemBuilder: (BuildContext context, int index) {
                  final belligerent = controller.belligerents[index];
                  return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/parchment.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                RpgAwesome.crossed_swords,
                                                color: belligerent.belligerentType == BelligerentType.ally ? Colors.blue : Colors.red,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Visibility(
                                                visible: belligerent.tokenUrl != null && belligerent.tokenUrl != "",
                                                child: CachedNetworkImage(
                                                  height: 30,
                                                  width: 30,
                                                  imageUrl: belligerent.tokenUrl != null && belligerent.tokenUrl != "" ? belligerent.tokenUrl! : "",
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 9,
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    '${belligerent.name} ',
                                                    style: GoogleFonts.kalam(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 4,
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(children: <Widget>[
                                                const Icon(
                                                  Icons.security,
                                                  color: Colors.blueAccent,
                                                ),
                                                Text('${belligerent.defense}'),
                                                const Icon(
                                                  Icons.trending_up_outlined,
                                                  color: Colors.green,
                                                ),
                                                Text('${belligerent.currentInitiative}'),
                                              ]))),
                                      Expanded(
                                        flex: 8,
                                        child: GestureDetector(
                                            onTap: () => openEditHealthPointsAnimated(context, belligerent),
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                    child: Container(
                                                  height: 30,
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    child: LinearProgressIndicator(
                                                      value: controller.getCurrentRatioOfPvByUuid(belligerent.uuid),
                                                      backgroundColor: Colors.grey,
                                                      valueColor: AlwaysStoppedAnimation<Color>(controller.getBelligerentBarColor(belligerent.uuid)),
                                                    ),
                                                  ),
                                                )),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${belligerent.currentPv} / ${belligerent.maxPv}",
                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Visibility(
                                          visible: belligerent.debuffs.isNotEmpty,
                                          maintainSize: true,
                                          maintainState: true,
                                          maintainAnimation: true,
                                          child: PopupMenuButton<int>(
                                            icon: Icon(controller.showDebuffIcon(belligerent)),
                                            itemBuilder: (context) => belligerent.debuffs.map<PopupMenuItem<int>>((BelligerentDebuff currentDebuff) {
                                              return PopupMenuItem(
                                                  value: 1,
                                                  child: ElevatedButton.icon(
                                                    icon: Icon(currentDebuff.type?.icon),
                                                    label: Text('${currentDebuff.type!.label} - (${currentDebuff.durationInTurn} tours)'), // <-- Text
                                                    onPressed: () => openUpdateDebuff(context, belligerent.uuid, currentDebuff),
                                                  ));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(children: <Widget>[
                                                Visibility(
                                                  visible: belligerent.strength != null,
                                                  child: const Icon(
                                                    RpgAwesome.muscle_up,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: belligerent.strength != null,
                                                    child: Text('${controller.calculateMod(belligerent.strength)}${controller.showSuperiorAbility("str", belligerent)}')),
                                                Visibility(
                                                  visible: belligerent.dexterity != null,
                                                  child: const Icon(
                                                    RpgAwesome.feather_wing,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: belligerent.dexterity != null,
                                                    child: Text('${controller.calculateMod(belligerent.dexterity)}${controller.showSuperiorAbility("dex", belligerent)}')),
                                                Visibility(
                                                  visible: belligerent.constitution != null,
                                                  child: const Icon(
                                                    RpgAwesome.vest,
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: belligerent.constitution != null,
                                                    child: Text('${controller.calculateMod(belligerent.constitution)}${controller.showSuperiorAbility("con", belligerent)}')),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Visibility(
                                                  visible: belligerent.intelligence != null,
                                                  child: const Icon(
                                                    size: 20,
                                                    FontAwesome5.brain,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Visibility(
                                                    visible: belligerent.intelligence != null,
                                                    child: Text("${controller.calculateMod(belligerent.intelligence)}${controller.showSuperiorAbility('int', belligerent)}")),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Visibility(
                                                  visible: belligerent.wisdom != null,
                                                  child: const Icon(
                                                    FontAwesome5.eye,
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Visibility(
                                                    visible: belligerent.wisdom != null,
                                                    child: Text("${controller.calculateMod(belligerent.wisdom)}${controller.showSuperiorAbility('wis', belligerent)}")),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Visibility(
                                                  visible: belligerent.charisma != null,
                                                  child: const Icon(
                                                    RpgAwesome.speech_bubbles,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: belligerent.charisma != null,
                                                    child: Text("${controller.calculateMod(belligerent.charisma)}${controller.showSuperiorAbility('cha', belligerent)}")),
                                              ]))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: PopupMenuButton<int>(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Supprimer'),
                                      onPressed: () {
                                        controller.removeBelligerent(belligerent.uuid);
                                        Navigator.pop(context);
                                      },
                                    )),
                                PopupMenuItem(
                                    value: 2,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Modifier'),
                                      onPressed: () => openAddForm(context, belligerent.uuid),
                                    )),
                                PopupMenuItem(
                                    value: 3,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(RpgAwesome.aura),
                                      label: const Text("Ajouter altération d'état"),
                                      onPressed: () => openAddDebuff(context, belligerent.uuid),
                                    )),
                                PopupMenuItem(
                                    value: 4,
                                    enabled: belligerent.monsterId != null,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.zoom_in),
                                      label: const Text("Voir détail"),
                                      onPressed: () => controller.navigateToDetailsPage(context, belligerent),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              )),
          floatingActionButton: Wrap(
            direction: Axis.horizontal, //use vertical to show  on vertical axis
            children: <Widget>[
              Container(margin: const EdgeInsets.all(10), child: FloatingActionButton(heroTag: "addBelligerent", onPressed: () => openAddForm(context, ""), child: const Icon(Icons.add))),

              Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    heroTag: "rollTurn",
                    onPressed: () {
                      controller.rollInitiatives();
                    },
                    backgroundColor: Colors.deepPurpleAccent,
                    child: const Icon(Icons.casino),
                  )),

              // Add more buttons here
            ],
          ),
        );
      },
    );
  }

}
