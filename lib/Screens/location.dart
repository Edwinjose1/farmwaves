// ignore_for_file: sort_child_properties_last, prefer_final_fields, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart' as geocoding;
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {}; // Set of markers to be displayed on the map
  location.LocationData? currentLocation; // Nullable LocationData
  LatLng? selectedLocation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _moveToCurrentLocation();
  }

  // Function to move the map to the current location
  Future<void> _moveToCurrentLocation() async {
    var loc = location.Location();

    try {
      currentLocation = await loc.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      return; // Exit function if location retrieval fails
    }

    if (currentLocation != null) {
      final double latitude = currentLocation!.latitude!;
      final double longitude = currentLocation!.longitude!;

      setState(() {
        _markers.clear(); // Clear existing markers
        _markers.add(Marker(
          markerId: const MarkerId('CurrentLocation'),
          position: LatLng(
            latitude,
            longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'Latitude: $latitude, Longitude: $longitude',
          ),
        ));
      });

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              latitude,
              longitude,
            ),
            zoom: 15.0,
          ),
        ),
      );
    } else {
      // Handle the case where current location is null
      print('Current location is null');
    }
  }

  // Function to handle selecting a location on the map
  void _selectLocation(LatLng location) {
    setState(() {
      _markers.clear(); // Clear existing markers
      _markers.add(Marker(
        markerId: const MarkerId('SelectedLocation'),
        position: location,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      ));
      selectedLocation = location;
    });
  }

  // Function to handle pressing the "Save" button to confirm the selected location
 void _saveLocation() {
  if (selectedLocation != null) {
    print(
        'Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}');
    // You can use the selectedLocation.latitude and selectedLocation.longitude to get the latitude and longitude of the selected location

    // Prepare the data to be passed back
    Map<String, dynamic> locationData = {
      'latitude': selectedLocation!.latitude,
      'longitude': selectedLocation!.longitude,
    };

    // Pass the data back to the previous page
    Navigator.pop(context, locationData);
  } else if (currentLocation != null) {
    // If no location is selected, use the current location
    print(
        'Selected Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}');
    // Prepare the data to be passed back
    Map<String, dynamic> locationData = {
      'latitude': currentLocation!.latitude,
      'longitude': currentLocation!.longitude,
    };

    // Pass the data back to the previous page
    Navigator.pop(context, locationData);
  } else {
    print('No location selected');
  }
}


  // Function to search for a place
  Future<void> _searchPlace(String placeName) async {
    if (placeName.isEmpty) return;

    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        LatLng location =
            LatLng(locations.first.latitude, locations.first.longitude);
        mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 15.0));
        _selectLocation(location);
      }
    } catch (e) {
      print('Error searching place: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Demo'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            onTap: _selectLocation,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              // Default initial position
              target: LatLng(0.0, 0.0),
              zoom: 1.0,
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Place',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Adjust border radius
                          borderSide: const BorderSide(
                              color: Colors.black), // Adjust border color
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16), // Adjust content padding
                      ),
                      style: const TextStyle(
                        fontSize: 16, // Adjust text size
                        color: Colors.black, // Adjust text color
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _searchPlace(_searchController.text);
                      }
                    },
                    child: const Text('Search',style:TextStyle(color: Colors.white) ,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Change search button color
                    ),
                  ),
                ],
              ), 
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(backgroundColor: Colors.black,
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor:Colors.black,
        onPressed: _saveLocation,
        label: const Text('Save Location',style: TextStyle(color: Colors.white),), // Change floating button label
        icon: const Icon(Icons.save,color: Colors.white,),
        backgroundColor:
      Colors.amber, // Change floating button background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Position floating button at the bottom
    );
  }
}

