
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/change_address.dart';
import 'package:flutter_application_0/Screens/orderprocessingpage.dart';
import 'package:flutter_application_0/Screens/profile.dart';
import 'package:flutter_application_0/cart/widgets/medicinetile.dart';
// import 'package:flutter_application_0/order_deteails/bloc/item_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/order_deteails/addresssection.dart';
import 'package:flutter_application_0/order_deteails/medicineitems.dart';
import 'package:flutter_application_0/order_deteails/widget/Widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetailsPage extends StatefulWidget {
  final List<Medicine> medicalDetails;

  ItemDetailsPage({
    required this.medicalDetails,
  });

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  List<XFile> _images = [];
  bool _prescriptionSkipped = false;
  late int userId;
  UserDetails? addressDetails;
  bool _isLoading = true;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _loadData();

  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _loadUserId();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      setState(() {
        userId = int.tryParse(userIdString) ?? 0;
      });
    }
 
 try {
    final userDetails = await fetchUserDetails(userId);
    setState(() {
      addressDetails = userDetails as UserDetails?;
    });
    } catch (e) {
    // Handle any errors that occurred during the fetch operation
    print('Error fetching user details: $e');
  }
  }

  double calculateTotalAmount(List<Medicine> medicalDetails) {
    double totalAmount = 0.0;
    for (var med in medicalDetails) {
      totalAmount += med.price * med.quantity;
    }
    return totalAmount;
  }
 String baseUrl = 'http://${Pallete.ipaddress}:8000/api/user/';

   Future<UserDetails> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('${baseUrl}details/$userId/'));

    if (response.statusCode == 200) {
      print(response.body);
      return UserDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    double screenHeight = MediaQuery.of(context).size.height;
    double totalAmount = calculateTotalAmount(widget.medicalDetails);
return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home1()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if (addressDetails == null)
                      Column(
                        children: [
                        
                          GestureDetector(
                            onTap: () async {
                              final selectedAddress = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddressPage(medicalDetails: widget.medicalDetails,)),
                              );
                              if (selectedAddress != null && selectedAddress is UserDetails) {
                                _onAddressChanged(selectedAddress);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.10,
                                width: double.infinity,
                                color: const Color.fromARGB(255, 237, 235, 235),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Select Address',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      AddressSection(medicalDetails: widget.medicalDetails,
                        addressDetails: addressDetails,
                        onAddressChanged: _onAddressChanged,
                      ),
                    GestureDetector(
                      onTap: () {
                        openImagePickerBottomSheet();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: double.infinity,
                          color: const Color.fromARGB(255, 237, 235, 235),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.file_upload_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                'Upload prescription here',
                                style: TextStyle(color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Pallete.darkgreenColor,
                                  ),
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 120,
                                  child: const Text(
                                    "Upload Now",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildImageGrid(),
                    Buildsection(
                      heading: 'Medicine Details',
                      content: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.medicalDetails.length,
                        itemBuilder: (context, index) {
                          final med = widget.medicalDetails[index];
                          return MedicineItem(
                            onRemoveQuantity: () async {
                              if (_isButtonDisabled) return;
                              setState(() {
                                _isButtonDisabled = true;
                              });
                              if (med.quantity > 0) {
                                await updateQuantity(med.id, userId.toString(), med.quantity - 1);
                                setState(() {
                                  med.quantity -= 1;
                                });
                              }
                              setState(() {
                                _isButtonDisabled = false;
                              });
                            },
                            name: med.name,
                            quantity: med.quantity,
                            onAddQuantity: () async {
                              setState(() {
                                _isButtonDisabled = true;
                              });
                              if (med.quantity < 10) {
                                await updateQuantity(med.id, userId.toString(), med.quantity + 1);
                                setState(() {
                                  med.quantity += 1;
                                });
                              }
                              setState(() {
                                _isButtonDisabled = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Buildsection(
                      heading: 'Bill Details',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BillItem(
                            label: 'Total Amount',
                            amount: 'Rs. $totalAmount',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: _isLoading ? null : buildBottomNavigationBar(totalAmount),
      ),
    );
  }

  Widget buildBottomNavigationBar(double totalAmount) {
    return Container(
      decoration: const BoxDecoration(
        color: Pallete.darkgreenColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Amount: Rs. $totalAmount',
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 184, 142, 15),
              ),
            ),
            onPressed: () async {
              if (_prescriptionSkipped) {
                await _placeOrder(totalAmount);
              } else {
                await _continueButtonPressed(totalAmount);
              }
            },
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continueButtonPressed(double totalAmount) async {
    if (addressDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an address.'),
        ),
      );
      return;
    }
    if (_images.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Prescription Required'),
            content: const Text('Please upload your prescription to continue.'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _placeOrder(totalAmount);
                },
                child: const Text('Skip'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  openImagePickerBottomSheet();
                },
                child: const Text('Upload'),
              ),
            ],
          );
        },
      );
      return;
    }
    await _placeOrder(totalAmount);
  }

  Future<void> _placeOrder(double totalAmount) async {
    Map<String, dynamic> orderData = await constructOrderData(totalAmount);
    int? orderId = await sendOrderData(orderData, _images);
    print(orderId);
    print(orderData);
    if (orderId != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OrderProcessingPage()),
        (Route<dynamic> route) => false,
      );
      setState(() {});
    } else {
      // Handle error
    }
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
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
                icon: const Icon(Icons.close),
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

  Future<Map<String, dynamic>> constructOrderData(double totalAmount) async {
    List<Map<String, dynamic>> items = widget.medicalDetails.map((med) {
      return {
        'id': med.id,
        'name': med.name,
        'quantity': med.quantity,
        'price': med.price,
      };
    }).toList();
    final prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('user_id');

    Map<String, dynamic> deliveryAddress = {
      "phone": addressDetails!.phoneNumber,
      "name": addressDetails!.phoneNumber,
      "pincode": addressDetails!.address1,
      "house_no": addressDetails!.address2,
      "locality": addressDetails!.lastName,
      "type": true
    };

    Map<String, dynamic> orderData = {
      'user': storedUserId,
      'status': 'Pending',
      'total_price': totalAmount,
      'delivery_address': deliveryAddress,
      'payment_method': 'Credit',
      'items': items,
      'payment_status': 'Pending',
      'delivery_status': 'Pending',
    };

    return orderData;
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

  Future<void> pickImagesFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      List<XFile>? galleryImages = await _picker.pickMultiImage(
        imageQuality: 99,
        maxHeight: 600,
        maxWidth: 800,
      );
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
      XFile? cameraImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 99,
        maxHeight: 600,
        maxWidth: 800,
      );
      if (cameraImage != null) {
        setState(() {
          _images.add(cameraImage);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int?> sendOrderData(Map<String, dynamic> orderData, List<XFile> images) async {
    try {
      final response = await http.post(
        Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final int orderId = responseData['order_id'];

        print('Order data sent successfully. Order ID: $orderId');

        for (var i = 0; i < images.length; i++) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/prescription/$orderId/'),
          );

          var file = images[i];
          var stream = http.ByteStream(File(file.path).openRead());
          var length = await File(file.path).length();
          var multipartFile = http.MultipartFile(
            'image',
            stream,
            length,
            filename: p.basename(file.path),
          );
          request.files.add(multipartFile);

          var imageResponse = await request.send();
          var imageResponseBody = await http.Response.fromStream(imageResponse);

          print('Image upload response status: ${imageResponse.statusCode}');
          print('Image upload response body: ${imageResponseBody.body}');

          if (imageResponse.statusCode == 200) {
            print('Image $i uploaded successfully.');
          } else {
            print('Failed to upload image $i: ${imageResponse.statusCode}');
            print('Failed to upload image $i response: ${imageResponseBody.body}');
          }
        }
        _images.clear();
        return orderId;
      } else {
        print('Failed to send order data: ${response.statusCode}');
        print('Order data response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending order data: $e');
      return null;
    }
  }


  void updateAddress(UserDetails newAddress) {
    setState(() {
      addressDetails = newAddress;
    });
  }

  void _onAddressChanged(UserDetails newAddress) async{
  
    final userDetails = await fetchUserDetails(userId);
    setState(() {
      addressDetails = userDetails;
    });
    print(addressDetails);
  }
}

