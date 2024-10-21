import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Item {
  final String name;
  final double latitude;
  final double longitude;
  final String category;

  Item({required this.name, required this.latitude, required this.longitude, required this.category});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      category: json['category'],
    );
  }
}

class DataService {
  static const String _key = 'items';

  // Zufällige Item-Generierung
  List<Item> generateRandomItems(int count) {
    final Random random = Random();
    final categories = ['Category A', 'Category B', 'Category C'];

    List<Item> items = List.generate(count, (index) {
      String name = 'Item ${index + 1}';
      double latitude = random.nextDouble() * 180 - 90; // Zufällige Breite
      double longitude = random.nextDouble() * 360 - 180; // Zufällige Länge
      String category = categories[random.nextInt(categories.length)];
      return Item(name: name, latitude: latitude, longitude: longitude, category: category);
    });

    return items;
  }

  Future<List<Item>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString(_key);
    if (itemsString != null) {
      List<dynamic> jsonList = jsonDecode(itemsString);
      return jsonList.map((json) => Item.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveItems(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<void> generateAndSaveSampleItems() async {
    List<Item> randomItems = generateRandomItems(10); // Erstelle 10 Beispiel-Items
    await saveItems(randomItems);
  }
}
