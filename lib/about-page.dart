import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocompagnon/combat-page-controller.dart';
import 'package:cocompagnon/combat-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'belligerent.dart';
import 'monster.dart';
import 'monsters-page-controller.dart';
import 'monsters-page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider<MonstersPageController>(create: (BuildContext context) {
      var monsterPageController = MonstersPageController();
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
          title: const Text('A propos', style: TextStyle(fontSize: 17, color: Colors.white)),
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
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: SizedBox(
                height: 2000,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Remerciements \n\n',
                      style: GoogleFonts.kalam(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text:
                              "Je remercie particulièrement Nicolas Bédé, administrateur du site web www.co-drs.org pour m'avoir permis d'utiliser les données de CO-DRS ainsi que les visuels des créatures. \n\n",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        TextSpan(
                          text:
                          "Je remercie également Adam, Thomas, Jason, Rudy qui ont fait office de testeurs. \n\n",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        TextSpan(text: "Tous les visuels de créatures dans l'application ont été généré par Nicolas Bédé pour co-drs.", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
