import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../data_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<Item> _items = [];
  final DataService _dataService = DataService();
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadItems();
    _getCurrentLocation();
    _location.onLocationChanged.listen((LocationData locationData) {
      _updateLocation(locationData);
    });
  }

  Future<void> _loadItems() async {
    List<Item> savedItems = await _dataService.loadItems();
    if (savedItems.isEmpty) {
      // Wenn keine gespeicherten Items vorhanden sind, füge Beispielwerte
      await _dataService.generateAndSaveSampleItems(); // Generiere und speichere Beispiel-Items
      savedItems = await _dataService.loadItems(); // Lade die gespeicherten Items erneut
    }
  print("Items: " + savedItems.toString());
    setState(() {
      _items.addAll(savedItems);
      _setMarkers(); // Setze die Marker nach dem Laden der Items
    });
  }

  void _setMarkers() {
    Set<Marker> markers = _items.map((item) {
      return Marker(
        markerId: MarkerId(item.name),
        position: LatLng(item.latitude, item.longitude),
        infoWindow: InfoWindow(title: item.name, snippet: item.category),
      );
    }).toSet();
    setState(() {
      _markers = markers;
    });
  }

  Future<void> _getCurrentLocation() async {
    final LocationData locationData = await _location.getLocation();
    _updateLocation(locationData);
  }

  void _updateLocation(LocationData locationData) {
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
