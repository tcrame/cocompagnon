import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocompagnon/combat-page-controller.dart';
import 'package:cocompagnon/monsters-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'about-page.dart';
import 'belligerent.dart';

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

  void openAddDebuff(BuildContext context, String updateUuid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final controller = context.watch<CombatPageController>();
        controller.initRemainingDebuffForBelligerent(updateUuid);

        return StatefulBuilder(
            builder: (context, setStateSB) => AlertDialog(
                  scrollable: true,
                  title: Text(controller.getModalDebuffTitle(updateUuid)),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: [
                          DropdownButton<String>(
                            value: controller.belligerentDebuffType.name,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              setStateSB(() {
                                controller.updateBelligerentDebuffType(value);
                              });
                            },
                            items: controller.getRemainingDebuffsForBelligerent(updateUuid).map<DropdownMenuItem<String>>((BelligerentDebuffType value) {
                              return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Row(children: <Widget>[
                                    Icon(
                                      value.icon,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(value.label),
                                  ]));
                            }).toList(),
                          ),
                          TextField(
                            controller: controller.debuffCommentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: "Commentaire",
                              icon: Icon(Icons.comment),
                            ),
                          ),
                          TextFormField(
                            controller: controller.debuffNbTurnsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "Nombre de tours",
                              icon: Icon(Icons.lock_clock),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Annuler"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Ajouter"),
                      onPressed: () {
                        controller.addDebuffToBelligerentById(updateUuid);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
      },
    );
  }

  void openUpdateDebuff(BuildContext context, String updateUuid, BelligerentDebuff debuff) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final controller = context.watch<CombatPageController>();
        controller.initEditDebuffControllers(updateUuid, debuff);

        return StatefulBuilder(
            builder: (context, setStateSB) => AlertDialog(
                  scrollable: true,
                  title: Text("Modifier altération ${debuff.type?.label}"),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: [
                          Text(debuff.type!.label),
                          TextField(
                            controller: controller.debuffCommentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: "Commentaire",
                              icon: Icon(Icons.comment),
                            ),
                          ),
                          TextFormField(
                            controller: controller.debuffNbTurnsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "Nombre de tours",
                              icon: Icon(Icons.lock_clock),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Annuler"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Supprimer"),
                      onPressed: () {
                        controller.removeDebuffToBelligerent(updateUuid, debuff);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Modifier"),
                      onPressed: () {
                        controller.updateDebuffToBelligerentById(updateUuid, debuff);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
      },
    );
  }

  void openAddForm(BuildContext context, String updateUuid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final controller = context.watch<CombatPageController>();

        final _formKey = GlobalKey<FormState>();
        controller.initControllers(updateUuid);

        return StatefulBuilder(
            builder: (context, setStateSB) => AlertDialog(
                  scrollable: true,
                  title: Text(controller.getModalTitle(updateUuid)),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'obligatoire';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Nom",
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            controller: controller.currentPvController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'obligatoire';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "PV actuel",
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.maxPvController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'obligatoire';
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "Max PV",
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.defenseController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'obligatoire';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Defense",
                              icon: Icon(
                                Icons.security,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.initiativeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'obligatoire';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Initiative",
                              icon: Icon(Icons.trending_up_outlined, color: Colors.green),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text('Allié'),
                                leading: Radio<BelligerentType>(
                                  value: BelligerentType.ally,
                                  groupValue: controller.belligerentType,
                                  onChanged: (BelligerentType? value) {
                                    setStateSB(() {
                                      controller.updateBelligerentType(value);
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Ennemi'),
                                leading: Radio<BelligerentType>(
                                  value: BelligerentType.enemy,
                                  groupValue: controller.belligerentType,
                                  onChanged: (BelligerentType? value) {
                                    setStateSB(() {
                                      controller.updateBelligerentType(value);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: controller.strengthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "FOR",
                              icon: Icon(
                                RpgAwesome.muscle_up,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.dexterityController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "DEX",
                              icon: Icon(
                                RpgAwesome.feather_wing,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.constitutionController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "CON",
                              icon: Icon(
                                RpgAwesome.vest,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.intelligenceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "INT",
                              icon: Icon(
                                size: 20,
                                FontAwesome5.brain,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.wisdomController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "SAG",
                              icon: Icon(
                                FontAwesome5.eye,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.charismaController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "CHA",
                              icon: Icon(
                                RpgAwesome.speech_bubbles,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.tokenUrlController,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              labelText: "Token URL",
                              icon: Icon(
                                FontAwesome5.file_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Text('Characteristiques supérieures'),
                          const SizedBox(height: 5.0),
                          Wrap(
                            spacing: 5.0,
                            children: SuperiorCaracteristics.values.map((SuperiorCaracteristics superiorCaract) {
                              var selectedFilter = controller.superiorCaracteristics.contains(superiorCaract);
                              return FilterChip(
                                backgroundColor: Colors.white,
                                selectedColor: Colors.green,
                                label: Text(
                                  superiorCaract.label,
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
                                  setStateSB(() {
                                    controller.removeOrAddSuperiorCaracteristicSelection(selectedFilter, superiorCaract);
                                  });
                                },
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Annuler"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text(updateUuid == "" ? "Ajouter" : "Modifier"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var defense = controller.defenseController.text != "" ? int.parse(controller.defenseController.text) : 0;
                          var initiative = controller.initiativeController.text != "" ? int.parse(controller.initiativeController.text) : 0;
                          var maxPv = controller.maxPvController.text != "" ? int.parse(controller.maxPvController.text) : 0;
                          var currentPv = controller.currentPvController.text != "" ? int.parse(controller.currentPvController.text) : 0;

                          var strength = controller.strengthController.text != "" ? int.parse(controller.strengthController.text) : null;
                          var dexterity = controller.dexterityController.text != "" ? int.parse(controller.dexterityController.text) : null;
                          var constitution = controller.constitutionController.text != "" ? int.parse(controller.constitutionController.text) : null;
                          var intelligence = controller.intelligenceController.text != "" ? int.parse(controller.intelligenceController.text) : null;
                          var wisdom = controller.wisdomController.text != "" ? int.parse(controller.wisdomController.text) : null;
                          var charisma = controller.charismaController.text != "" ? int.parse(controller.charismaController.text) : null;
                          var tokenUrl = controller.charismaController.text != "" ? controller.tokenUrlController.text : null;

                          Map<String, bool> superiorCaracs = {};
                          SuperiorCaracteristics.values.forEach((element) {
                            superiorCaracs[element.name] = controller.superiorCaracteristics.contains(element);
                          });

                          if (updateUuid == "") {
                            controller.addBelligerent(controller.nameController.text, defense, initiative, currentPv, maxPv, controller.belligerentType, null, strength, dexterity, constitution,
                                intelligence, wisdom, charisma, superiorCaracs, tokenUrl);
                          } else {
                            controller.editBelligerent(updateUuid, controller.nameController.text, defense, initiative, currentPv, maxPv, controller.belligerentType, strength, dexterity, constitution,
                                intelligence, wisdom, charisma, superiorCaracs, tokenUrl);
                            Navigator.pop(context);
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ));
      },
    );
  }

  void openEditHealthPointsAnimated(BuildContext context, Belligerent belligerent) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final controller = context.watch<CombatPageController>();
        controller.resetDmControllers();
        var curve = Curves.easeInOut.transform(a1.value);
        return StatefulBuilder(
            builder: (context, setStateSB) => Transform.scale(
                  scale: curve,
                  child: AlertDialog(
                    title: Text(belligerent.name),
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_left),
                                      color: Colors.white,
                                      onPressed: () {
                                        setStateSB(() {
                                          controller.removeHealthFromBelligerent(belligerent);
                                        });
                                      },
                                    ),
                                  )),
                              Expanded(
                                flex: 8,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 50,
                                          child: LinearProgressIndicator(
                                            value: controller.getCurrentRatioOfPvByUuid(belligerent.uuid),
                                            backgroundColor: Colors.grey,
                                            valueColor: AlwaysStoppedAnimation<Color>(controller.getBelligerentBarColor(belligerent.uuid)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${belligerent.currentPv} / ${belligerent.maxPv}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                foreground: Paint()
                                                  ..style = PaintingStyle.fill
                                                  ..strokeWidth = 6
                                                  ..color = Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_right),
                                      color: Colors.white,
                                      onPressed: () {
                                        setStateSB(() {
                                          controller.addHealthFromBelligerent(belligerent);
                                        });
                                      },
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: TextFormField(
                                    controller: controller.addDamageController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    decoration: const InputDecoration(
                                      labelText: "DM",
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                    icon: const Icon(Icons.heart_broken, color: Colors.red),
                                    label: const Text('Infliger DM'),
                                    onPressed: () {
                                      setStateSB(() {
                                        controller.inflictDamage(belligerent);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: TextFormField(
                                    controller: controller.removeDamageController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    decoration: const InputDecoration(
                                      labelText: "Soin",
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                    icon: const Icon(Icons.healing, color: Colors.green),
                                    label: const Text('Soigner'),
                                    onPressed: () {
                                      setStateSB(() {
                                        controller.healDamage(belligerent);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ))
                    ],
                  ),
                ));
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
