import 'package:cocompagnon/controllers/combat-page-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../../models/belligerent.dart';

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
