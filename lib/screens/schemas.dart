import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../databases/databases.dart';

class MainSchemas extends StatefulWidget {
  const MainSchemas({super.key});

  @override
  State<MainSchemas> createState() => _MainSchemasState();
}

class _MainSchemasState extends State<MainSchemas> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _url = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schemas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSchemas(),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(4),
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
    final box = await Hive.openBox<DBSchemas>("DBSchemas");
    box.values.forEach((element) {
      widgets.add(
        Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(element.key.toString()),
          onDismissed: (direction) async {
            final box = await Hive.openBox<DBSchemas>("DBSchemas");
            box.delete(element.key);
            await box.close();
          },
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: Colors.red.shade900,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete_rounded,
              color: Colors.white,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: ListTile(
              title: Text(
                element.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.amber,
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditSchema(element: element),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                  IconButton(
                    color: Colors.green,
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                    ),
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text("ID:"),
                                  const SizedBox(height: 5),
                                  TextField(
                                    controller: _id,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text("URL:"),
                                  const SizedBox(height: 5),
                                  TextField(
                                    controller: _url,
                                    keyboardType: TextInputType.url,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      _addProduct(element);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      minimumSize: const Size(350, 50),
                                    ),
                                    child: const Text(
                                      "Add Product",
                                      style: TextStyle(
                                        color: Color(0xFF001019),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });

    await box.close();
    return widgets;
  }

  void _addProduct(element) async {
    final box = await Hive.openBox<DBProducts>("DBProducts");
    box.add(
      DBProducts(
        id: int.parse(_id.text),
        key: element.key,
        url: _url.text,
      ),
    );
    await box.close();
  }
}

class AddSchemas extends StatefulWidget {
  const AddSchemas({super.key});

  @override
  State<AddSchemas> createState() => _AddSchemasState();
}

class _AddSchemasState extends State<AddSchemas> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _priceSelectorA = TextEditingController();
  final TextEditingController _priceSelectorB = TextEditingController();
  final TextEditingController _discountSelector = TextEditingController();
  final TextEditingController _percentage = TextEditingController();
  String _selectedCurrency = "Rial";
  bool _checkBox = false;

  bool _checkBoxInput = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  const Text("Name:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _name,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 8),
                  const Text("Price selector:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _priceSelectorA,
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const Text("Price selector:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _priceSelectorB,
                  ),
                  const SizedBox(height: 8),
                  const Text("Discount Price selector:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _discountSelector,
                  ),
                  const Divider(),
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
                  const SizedBox(height: 8),
                  const Text("Percentage:"),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _percentage,
                          readOnly: !_checkBoxInput,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}?%?$'),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        activeColor: Colors.amber,
                        checkColor: Colors.black,
                        value: _checkBoxInput,
                        onChanged: (value) {
                          setState(() {
                            _checkBoxInput = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: [
                    const Text("Price before discount:"),
                    Checkbox(
                      activeColor: Colors.amber,
                      checkColor: Colors.black,
                      value: _checkBox,
                      onChanged: (value) {
                        setState(() {
                          _checkBox = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _create();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Color(0xFF001019),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _create() async {
    if (_name.text.isEmpty || _priceSelectorA.text.isEmpty) {
      return;
    }
    var box = await Hive.openBox<DBSchemas>("DBSchemas");
    box.add(
      DBSchemas(
        name: _name.text,
        priceSelectorA: _priceSelectorA.text,
        priceSelectorB:
            _priceSelectorB.text.isEmpty ? null : _priceSelectorB.text,
        discountSelector:
            _discountSelector.text.isEmpty ? null : _discountSelector.text,
        currency: _selectedCurrency,
        percentage: _checkBoxInput ? num.tryParse(_percentage.text) : null,
        priceBeforeDiscount: _checkBox,
      ),
    );
    await box.close();
    Navigator.pop(context);
  }
}

class EditSchema extends StatefulWidget {
  final DBSchemas element;

  EditSchema({required this.element});

  @override
  State<EditSchema> createState() => _EditSchemaState();
}

class _EditSchemaState extends State<EditSchema> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _priceSelectorA = TextEditingController();
  final TextEditingController _priceSelectorB = TextEditingController();
  final TextEditingController _discountSelector = TextEditingController();
  final TextEditingController _percentage = TextEditingController();
  String _selectedCurrency = "Rial";
  bool _checkBox = false;

  bool _checkBoxInput = false;

  @override
  void initState() {
    super.initState();
    _name.text = widget.element.name;
    _priceSelectorA.text = widget.element.priceSelectorA;
    _priceSelectorB.text = widget.element.priceSelectorB ?? "";
    _discountSelector.text = widget.element.discountSelector ?? "";
    _percentage.text = widget.element.percentage == null
        ? ""
        : widget.element.percentage.toString();
    _selectedCurrency = widget.element.currency;
    _checkBox = widget.element.priceBeforeDiscount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  const Text("Name:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _name,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 8),
                  const Text("Price selector:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _priceSelectorA,
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const Text("Price selector:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _priceSelectorB,
                  ),
                  const SizedBox(height: 8),
                  const Text("Discount Price selector:"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _discountSelector,
                  ),
                  const Divider(),
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
                  const SizedBox(height: 8),
                  const Text("Percentage:"),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _percentage,
                          readOnly: !_checkBoxInput,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}?%?$'),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        activeColor: Colors.amber,
                        checkColor: Colors.black,
                        value: _checkBoxInput,
                        onChanged: (value) {
                          setState(() {
                            _checkBoxInput = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: [
                    const Text("Price before discount:"),
                    Checkbox(
                      activeColor: Colors.amber,
                      checkColor: Colors.black,
                      value: _checkBox,
                      onChanged: (value) {
                        setState(() {
                          _checkBox = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: edit,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0xFF001019),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void edit() async {
    var box = await Hive.openBox<DBSchemas>("DBSchemas");
    box.put(
      widget.element.key,
      DBSchemas(
        name: _name.text,
        priceSelectorA: _priceSelectorA.text,
        priceSelectorB:
            _priceSelectorB.text.isEmpty ? null : _priceSelectorB.text,
        discountSelector:
            _discountSelector.text.isEmpty ? null : _discountSelector.text,
        currency: _selectedCurrency,
        percentage: _checkBoxInput ? num.tryParse(_percentage.text) : null,
        priceBeforeDiscount: _checkBox,
      ),
    );
    await box.close();
    Navigator.pop(context);
  }
}
