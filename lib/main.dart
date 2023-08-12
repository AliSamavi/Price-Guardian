import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'databases/databases.dart';
import 'screens/about.dart';
import 'screens/dashboard.dart';
import 'screens/schemas.dart';
import 'screens/stores.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DBStoresAdapter());
  Hive.registerAdapter(DBSchemasAdapter());
  Hive.registerAdapter(DBProductsAdapter());
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoSlabTextTheme(
          Theme.of(context).textTheme.copyWith(
                titleLarge: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                bodyMedium: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF001019),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.amber),
          ),
        ),
      ),
      home: Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF001019),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: 0 == _currentPageIndex ? Colors.amber : Colors.grey,
                icon: const Icon(Icons.dashboard_rounded),
                onPressed: () {
                  setState(() {
                    _currentPageIndex = 0;
                  });
                },
              ),
              IconButton(
                color: 1 == _currentPageIndex ? Colors.amber : Colors.grey,
                icon: const Icon(Icons.store_rounded),
                onPressed: () {
                  setState(() {
                    _currentPageIndex = 1;
                  });
                },
              ),
              IconButton(
                color: 2 == _currentPageIndex ? Colors.amber : Colors.grey,
                icon: const Icon(Icons.flip_rounded),
                onPressed: () {
                  setState(() {
                    _currentPageIndex = 2;
                  });
                },
              ),
              IconButton(
                color: 3 == _currentPageIndex ? Colors.amber : Colors.grey,
                icon: const Icon(Icons.error_rounded),
                onPressed: () {
                  setState(() {
                    _currentPageIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
        body: buildPage(_currentPageIndex),
      ),
    );
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return const MainDashboard(); // Dashboard
      case 1:
        return const MainStores(); // Stores
      case 2:
        return const MainSchemas(); // Schemas & Products
      case 3:
        return const MainAbout(); // About
      default:
        return Container();
    }
  }
}
