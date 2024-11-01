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
      await _dataService.generateAndSaveSampleItems();
      savedItems = await _dataService.loadItems(); // Items erneut laden
    }
    setState(() {
      _items.addAll(savedItems);
    });
  }

  void _addItem(String name, double latitude, double longitude, String category) {
    final newItem = Item(name: name, latitude: latitude, longitude: longitude, category: category);
    setState(() {
      _items.add(newItem);
    });
    _dataService.saveItems(_items);
    Navigator.of(context).pop(); // Schließe das Modal nach dem Hinzufügen
  }

  void _openAddItemSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String category = 'Category A';
        String latitude = '';
        String longitude = '';

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
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                onChanged: (value) => latitude = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                onChanged: (value) => longitude = value,
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
                onPressed: () {
                  if (latitude.isNotEmpty && longitude.isNotEmpty) {
                    _addItem(name, double.parse(latitude), double.parse(longitude), category);
                  }
                },
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
      body: _items.isEmpty // Überprüfe, ob die Liste leer ist
          ? const Center(child: CircularProgressIndicator()) // Ladeanzeige
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'Lat: ${item.latitude}, Lng: ${item.longitude} - ${item.category}',
                    style: const TextStyle(color: Colors.grey),
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
