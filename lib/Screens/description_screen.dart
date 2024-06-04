import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';

class DescriptionScreen extends StatelessWidget {
  final String id;
  final String heading;
  final String description;
  final String imageUrl;

  const DescriptionScreen({
    Key? key,
    required this.id,
    required this.heading,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
  backgroundColor: Pallete.whiteColor,
  leading: GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: const Icon(
      Icons.arrow_back_ios, // Use the Cupertino-style back button icon
      color: Colors.black,
    ),
  ),
),
      body: Container(
        // color: Pallete.greenColor,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                heading,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
