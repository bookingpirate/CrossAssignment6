import 'package:flutter/material.dart';
import '../data_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Item> _items = [];
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadItems(); // Lade die Items beim Start der App
  }

  Future<void> _loadItems() async {
    List<Item> savedItems = await _dataService.loadItems();
    if (savedItems.isEmpty) {
      // Wenn keine gespeicherten Items vorhanden sind, füge die Beispielwerte hinzu
      savedItems.addAll(_dataService.getSampleItems());
    }
    setState(() {
      _items.addAll(savedItems);
    });
  }

  void _addItem(String name, String location, String category) {
    setState(() {
      _items.add(Item(name: name, location: location, category: category));
    });
    _dataService.saveItems(_items); // Speichere die Liste
    Navigator.of(context).pop(); // Schließe das Bottom Sheet
  }

  void _openAddItemSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String location = '';
        String category = 'Category A'; // Default-Wert

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) => location = value,
              ),
              DropdownButton<String>(
                value: category,
                items: <String>[
                  'Category A',
                  'Category B',
                  'Category C',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addItem(name, location, category),
                child: const Text('Add Item'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(
              item.name,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              '${item.location} - ${item.category}',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddItemSheet,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
