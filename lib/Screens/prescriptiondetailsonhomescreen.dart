import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/orderprocessingpage.dart';
import 'package:flutter_application_0/constants/pallete.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionFormfield extends StatefulWidget {
  @override
  _PrescriptionFormfieldState createState() => _PrescriptionFormfieldState();
}

class _PrescriptionFormfieldState extends State<PrescriptionFormfield> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController medicineDetailsController = TextEditingController();

  List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Center(
                child: GestureDetector(
                  onTap: openImagePickerBottomSheet,
                  child: ClipOval(
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.cyan,
                      child: Icon(
                        Icons.file_upload,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(child: Text('Tap here to upload prescription')),
                  SizedBox(height: 50),
              _buildImageGrid(),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Name', nameController),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField('Mobile Number', mobileController),
                  ),
                ],
              ),
              _buildSectionTitle("Address Details"),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Locality/Town', localityController),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField('House No', addressController),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              _buildTextField('Pincode', pincodeController),
              _buildSectionTitle("Medicine Details"),
              _buildTextField('Medicine Details', medicineDetailsController),
              const SizedBox(height: 10.0),
              _buildTextField('Remark', remarkController),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: saveAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.darkgreenColor,
            minimumSize: const Size(double.infinity, 50.0),
          ),
          child: Text(
            'Place Order',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 21, 27, 26)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }

  void saveAddress() async {
     _images.clear();
     
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderProcessingPage()),
    );
  }

  Future<void> openImagePickerBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(File(_images[index].path)),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _images.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickImagesFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      List<XFile>? galleryImages = await _picker.pickMultiImage();
      if (galleryImages != null && galleryImages.isNotEmpty) {
        setState(() {
          _images.addAll(galleryImages);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? cameraImage = await _picker.pickImage(source: ImageSource.camera);
      if (cameraImage != null) {
        setState(() {
          _images.add(cameraImage);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}