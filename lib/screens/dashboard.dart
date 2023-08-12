import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../backend/scraper.dart';
import '../databases/databases.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  bool _isLoading = false;
  String? _selectedStore = null;
  String? _selectedSchema = null;
  List<String> _stores = [];
  List<String> _schemas = [];
  List<int> _keyStores = [];
  List<int> _keySchemas = [];

  @override
  void initState() {
    super.initState();
    stores();
    schemas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              child: AbsorbPointer(
                absorbing: _isLoading,
                child: IconButton(
                  color: Colors.black,
                  iconSize: 80,
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Icon(Icons.power_settings_new_rounded),
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                    } else {
                      if (_selectedStore != null && _selectedSchema != null) {
                        _isLoading = true;
                        setState(() {});

                        WebScraper(
                          keyStore:
                              _keyStores[_stores.indexOf(_selectedStore!)],
                          keySchema:
                              _keySchemas[_schemas.indexOf(_selectedSchema!)],
                        );

                        _isLoading = false;
                        setState(() {});
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Store:"),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                  ),
                  value: _selectedStore,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStore = newValue!;
                    });
                  },
                  items: _stores.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                const Text("Schema:"),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                  ),
                  value: _selectedSchema,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSchema = newValue!;
                    });
                  },
                  items: _schemas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> stores() async {
    final box = await Hive.openBox<DBStores>("DBStores");
    box.values.forEach((element) {
      _stores.add(element.storeName);
      _keyStores.add(element.key);
    });
    await box.close();
    setState(() {});
  }

  Future<void> schemas() async {
    final box = await Hive.openBox<DBSchemas>("DBSchemas");
    box.values.forEach((element) {
      _schemas.add(element.name);
      _keySchemas.add(element.key);
    });
    await box.close();
    setState(() {});
  }
}
