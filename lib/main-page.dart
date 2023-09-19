import 'package:cocompagnon2/main-page-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'belligerent.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainPageController>(
      create: (BuildContext context) {
        var mainPageController = MainPageController();
        mainPageController.restoreBelligerents();
        mainPageController.restoreCurrentTurn();
        return mainPageController;
      },
      builder: (context, child) {
        final controller = context.watch<MainPageController>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text("Suivi des initiatives - Tour ${controller.turn}")
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: const Icon(Icons.restart_alt),
                        onPressed: () => controller.resetTurns(),
                      )
                  ),
            ])
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: controller.belligerents.length,
            itemBuilder: (BuildContext context, int index) {
              final belligerent = controller.belligerents[index];
              return Container(
                  height: 50,
                  color: belligerent.belligerentType == BelligerentType.ally ? Colors.blue[200] : Colors.red[200],
                  child: Center(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 6,
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(children: <Widget>[
                                Text('${belligerent.name} - '),
                                const Icon(
                                  Icons.shield,
                                  color: Colors.blueGrey,
                                ),
                                Text('${belligerent.defense}'),
                                const Icon(
                                  Icons.trending_up_outlined,
                                  color: Colors.yellow,
                                ),
                                Text('${belligerent.currentInitiative}'),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                ),
                                Text('${belligerent.currentPv} / ${belligerent.maxPv}'),
                              ]))),
                      Expanded(
                        flex: 2,
                        child: LinearProgressIndicator(
                          value: controller.getCurrentRatioOfPvByUuid(belligerent.uuid),
                          semanticsLabel: 'Linear progress indicator',
                          valueColor: AlwaysStoppedAnimation<Color>(controller.getBelligerentBarColor(belligerent.uuid)),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Visibility(
                            visible: belligerent.debuffs.isNotEmpty,
                            child: PopupMenuButton<int>(
                              icon: const Icon(Icons.sentiment_very_dissatisfied),
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
                          )),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    controller.removeBelligerent(belligerent.uuid);
                                    Navigator.pop(context);
                                  },
                                )),
                            PopupMenuItem(
                                value: 2,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => openAddForm(context, belligerent.uuid),
                                )),
                            PopupMenuItem(
                                value: 3,
                                child: IconButton(
                                  icon: const Icon(Icons.sentiment_very_dissatisfied),
                                  onPressed: () => openAddDebuff(context, belligerent.uuid),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )));
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
          floatingActionButton: Wrap(
            //will break to another line on overflow
            direction: Axis.horizontal, //use vertical to show  on vertical axis
            children: <Widget>[
              Container(margin: EdgeInsets.all(10), child: FloatingActionButton(onPressed: () => openAddForm(context, ""), child: const Icon(Icons.add))),

              Container(
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton(
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
        final controller = context.watch<MainPageController>();
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
        final controller = context.watch<MainPageController>();
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
        final controller = context.watch<MainPageController>();

        controller.initControllers(updateUuid);

        return StatefulBuilder(
            builder: (context, setStateSB) => AlertDialog(
                  scrollable: true,
                  title: Text(controller.getModalTitle(updateUuid)),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.nameController,
                            decoration: const InputDecoration(
                              labelText: "Nom",
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            controller: controller.currentPvController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "PV actuel",
                              icon: Icon(Icons.favorite_border),
                            ),
                          ),
                          TextFormField(
                            controller: controller.maxPvController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "Max PV",
                              icon: Icon(Icons.favorite),
                            ),
                          ),
                          TextFormField(
                            controller: controller.defenseController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "Defense",
                              icon: Icon(Icons.shield),
                            ),
                          ),
                          TextFormField(
                            controller: controller.initiativeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: "Initiative",
                              icon: Icon(Icons.trending_up_outlined),
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
                          )
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
                        if (updateUuid == "") {
                          controller.addBelligerent(controller.nameController.text, int.parse(controller.defenseController.text), int.parse(controller.initiativeController.text),
                              int.parse(controller.currentPvController.text), int.parse(controller.maxPvController.text), controller.belligerentType);
                        } else {
                          controller.editBelligerent(updateUuid, controller.nameController.text, int.parse(controller.defenseController.text), int.parse(controller.initiativeController.text),
                              int.parse(controller.currentPvController.text), int.parse(controller.maxPvController.text), controller.belligerentType);
                          Navigator.pop(context);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
      },
    );
  }
}
