import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../about-page.dart';
import '../combat-page.dart';
import '../monsters-page.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}