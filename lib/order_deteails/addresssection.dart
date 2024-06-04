
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/change_address.dart';

class AddressSection extends StatefulWidget {
  final AddressDetails? addressDetails; // Make it nullable
  final Function(AddressDetails) onAddressChanged;

  AddressSection({
    required this.addressDetails,
    required this.onAddressChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddressSectionState createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  AddressDetails? _selectedAddress; // Make it nullable
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.addressDetails; // Initialize with widget's value
  }

  void _changeAddress() async {
    setState(() {
      _isLoading = true;
    });

    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressPage(),
      ),
    );

    if (selectedAddress != null) {
      setState(() {
        print(selectedAddress.name);
        _selectedAddress = selectedAddress;
        _isLoading = false;
      });
      widget.onAddressChanged(_selectedAddress!);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // ignore: sized_box_for_whitespace
        Container(
          width: double.infinity,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionContainer(
          'Delivery Address',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedAddress?.name ?? 'John Doe', // Use null-aware operators
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _selectedAddress?.locality ?? '123 Street, City',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _selectedAddress?.phone ?? '+1234567890',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _selectedAddress?.pincode ?? '12345',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _changeAddress,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _selectedAddress == null
                                  ? 'Select Address'
                                  : 'Change Address',
                              style: TextStyle(
                                color: _selectedAddress == null
                                    ? Colors.green
                                    : const Color.fromARGB(255, 2, 68, 130),
                                fontSize: 16.0,
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
      ],
    );
  }

  Widget _buildSectionContainer(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12.0),
          content,
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
