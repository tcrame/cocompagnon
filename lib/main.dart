import 'package:cocompagnon/utils/shared-preferences-utils.dart';
import 'package:flutter/material.dart';

import 'pages/monsters-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferencesUtils.readProfilesAsync();
    return MaterialApp(
        title: 'Chroniques oubliés compagnon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MonstersPage());
  }
}
