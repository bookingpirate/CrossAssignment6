import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Um JSON-Daten zu codieren und zu decodieren

class Item {
  final String name;
  final String location;
  final String category;

  Item({required this.name, required this.location, required this.category});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'category': category,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      location: json['location'],
      category: json['category'],
    );
  }
}

class DataService {
  static const String _key = 'items'; // Schlüssel für shared_preferences

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

  List<Item> getSampleItems() {
    return [
      Item(name: 'Sample Item 1', location: 'Location 1', category: 'Category A'),
      Item(name: 'Sample Item 2', location: 'Location 2', category: 'Category B'),
      Item(name: 'Sample Item 3', location: 'Location 3', category: 'Category C'),
      Item(name: 'Sample Item 4', location: 'Location 4', category: 'Category A'),
      Item(name: 'Sample Item 5', location: 'Location 5', category: 'Category B'),
      Item(name: 'Sample Item 6', location: 'Location 6', category: 'Category C'),
      Item(name: 'Sample Item 7', location: 'Location 7', category: 'Category A'),
      Item(name: 'Sample Item 8', location: 'Location 8', category: 'Category B'),
      Item(name: 'Sample Item 9', location: 'Location 9', category: 'Category C'),
      Item(name: 'Sample Item 10', location: 'Location 10', category: 'Category A'),
    ];
  }
}
