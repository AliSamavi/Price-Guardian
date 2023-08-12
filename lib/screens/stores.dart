import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../databases/databases.dart';

class MainStores extends StatefulWidget {
  const MainStores({super.key});

  @override
  State<MainStores> createState() => _MainStoresState();
}

class _MainStoresState extends State<MainStores> {
  final TextEditingController _storeName = TextEditingController();
  final TextEditingController _storeDomain = TextEditingController();
  final TextEditingController _storeToken = TextEditingController();
  String _selectedCurrency = "Rial";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: FutureBuilder<Widget>(
                        future: internetReview(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.data!;
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
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
        child: FutureBuilder<List<Widget>>(
          future: _buildList(),
          builder: (context, snapshot) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return snapshot.data?[index];
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Widget>> _buildList() async {
    final List<Widget> widgets = [];
    final box = await Hive.openBox<DBStores>("DBStores");
    box.values.forEach((element) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: ListTile(
            title: Text(
              element.storeName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(element.storeDomain),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
              onPressed: () async {
                final box = await Hive.openBox<DBStores>("DBStores");
                box.delete(element.key);
                await box.close();
                setState(() {});
              },
            ),
          ),
        ),
      );
    });
    await box.close();
    return widgets;
  }

  Future<Widget> internetReview() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return SizedBox(
        height: 250,
        child: Image.asset(
          "assets/images/connection-lost.png",
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text("Name:"),
          const SizedBox(height: 5),
          TextField(
            controller: _storeName,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 12),
          const Text("Domain:"),
          const SizedBox(height: 5),
          TextField(
            controller: _storeDomain,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              hintText: "example.com",
            ),
          ),
          const SizedBox(height: 12),
          const Text("Auth token:"),
          const SizedBox(height: 5),
          TextField(
            controller: _storeToken,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 12),
          const Text("Curency:"),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
              ),
            ),
            value: _selectedCurrency,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCurrency = newValue!;
              });
            },
            items: <String>["Rial", "Toman"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _addStore();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              minimumSize: const Size(350, 50),
            ),
            child: const Text(
              "Add store",
              style: TextStyle(
                color: Color(0xFF001019),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
  }

  void _addStore() async {
    try {
      final response = await http.get(
          Uri.https(_storeDomain.text, "/api/", {"ws_key": _storeToken.text}));
      if (response.statusCode == 200) {
        final data = DBStores(
            storeName: _storeName.text,
            storeDomain: _storeDomain.text,
            storeToken: _storeToken.text,
            storeCurrency: _selectedCurrency);
        _storeName.clear();
        _storeDomain.clear();
        _storeToken.clear();
        final box = await Hive.openBox<DBStores>("DBStores");
        box.add(data);
        await box.close();
        Navigator.of(context).pop();
        setState(() {});
      } else {
        _storeToken.clear();
      }
    } catch (e) {
      _storeDomain.clear();
    }
  }
}
