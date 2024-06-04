// ignore_for_file: avoid_print, unused_element, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/myorder/widgets/orderitems.dart';
import 'package:flutter_application_0/order_deteails/details_of_order_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/myorder/models/models.dart';
import 'package:flutter_application_0/Screens/paymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  OrderDetailsPage({super.key, required this.orderId});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool _showOrderedItemsTable = false;
  bool isLoading = true;
  late OrderTileData order;
  Timer? _timer;
  List<XFile> _images = [];
  late final List<int> productids = [];
    List<String> _imageUrls = [];
     bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchOrderDetails();
        fetchImages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchOrderDetails() async {
    final response = await http.get(Uri.parse(
        'http://${Pallete.ipaddress}:8000/api/orders/${widget.orderId}/'));

    if (response.statusCode == 200) {
      setState(() {
        order = OrderTileData.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      // Handle error appropriately
      throw Exception('Failed to load order details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderInfo(),
                  const SizedBox(height: 20.0),
                  _showOrderedItemsTable
                      ? Orderitems(order: order)
                      : const SizedBox(),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showOrderedItemsTable = !_showOrderedItemsTable;
                      });
                    },
                    child: Text(_showOrderedItemsTable
                        ? 'Hide Ordered Items'
                        : 'Show Ordered Items'),
                  ),


                  const SizedBox(height: 20,),
              _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _imageUrls.isNotEmpty
                        ? _buildImageList()
                        : const Center(child: Text('No images found')),
                ],
              ),
            ),
    );
  }
Widget _buildImageList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Prescription Images:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 8),
      GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: _imageUrls
            .map(
              (url) => Image.network(
                url,
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    ],
  );
}
  Widget _buildOrderInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: QM-0024-${order.id}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.black87),
          ),
          const SizedBox(height: 12.0),
          Text('Order Date: ${order.orderDate}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
          const SizedBox(height: 8.0),
          Text('Delivery Address: ${order.deliveryAddress}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
          const SizedBox(height: 8.0),
          Text('Total Price: ${order.totalPrice}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
          const SizedBox(height: 8.0),
          if (order.status == 'payment success')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Method: ${order.paymentMethod}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
                const SizedBox(height: 8.0),
                Text('Payment Method: ${order.paymentStatus}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
                const SizedBox(height: 8.0),
              ],
            ),
          // Text('Delivery Status: ${order.deliveryStatus}', style: TextStyle(fontSize: 16.0, color: Colors.black54)),
          // SizedBox(height: 8.0),
          if (order.status == 'reject open' || order.status == 'reject close')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Remarks: ${order.remarks}',
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8.0),
              ],
            ),
          Text('Status: ${order.status}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
          const SizedBox(height: 8.0),
          if (order.status == 'approved' && order.paymentStatus == 'Pending')
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(orderId: order.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Payment', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          if (order.status == 'reject open')
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showPrescriptionUploadDialog();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Upload Prescription',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          if (_images
              .isNotEmpty) // Conditionally show the uploading button if images are selected
            ElevatedButton(
              onPressed: ()async {
               await uploadImages();
               Navigator.pop(context);
                // Add your code to handle uploading images here
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child:
                  const Text('Upload Images', style: TextStyle(color: Colors.white)),
            ),
          if (order.deliveryStatus == 'complete')
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showReturnOptionDialog();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Return', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          if (order.status == 'approved' ||
              order.status == 'reject open' ||
              order.status == 'Pending')
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showCancelOptionDialog();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Cancel Order',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          if (order.status == 'delivered')
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // _showCancelOptionDialog();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 111, 88, 4)),
                  child: const Text('Return', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    reorderProduct();
                    // _showCancelOptionDialog();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 22, 7, 76)),
                  child:
                      const Text('Re Order', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
    // Display the selected images grid
        ],
      ),
    );
  }

  void _showPrescriptionUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Prescription'),
          content: const Text('Please upload your prescription to proceed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Code to handle prescription upload
                // For now, let's assume the prescription upload is successful
                // Show a confirmation dialog
                Navigator.pop(context); // Close the upload prescription dialog
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    // ignore: avoid_unnecessary_containers
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
              },
              child: const Text('Upload'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the upload prescription dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showReturnOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Return Order'),
          content: const Text('Are you sure you want to return this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Code to handle return order
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: const Text('Are you sure you want to cancel this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                updatePaymentStatus(widget.orderId);
                // Code to handle cancel order
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }



  Future<int?> updatePaymentStatus(int orderId) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://${Pallete.ipaddress}:8000/api/orders/status/update/$orderId/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'Cancelled by User'}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Payment status updated successfully for order ID: $orderId');
        return orderId;
      } else {
        print('Failed to update payment status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating payment status: $e');
      return null;
    }
  }

  Future<void> _openImagePickerBottomSheet() async {
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
Future<void> fetchImages() async {
  try {
    final response = await http.get(
      Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/prescription/${widget.orderId}/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      setState(() {
        _imageUrls = responseBody.map((imageData) {
          // Prepend the host part to each image URL
          return 'http://${Pallete.ipaddress}:8000${imageData['image']}';
        }).toList();
        _isLoading = false;
      });
    } else {
      print('Failed to fetch images for order ${widget.orderId}: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  } catch (e) {
    print('Error fetching images for order ${widget.orderId}: $e');
    setState(() {
      _isLoading = false;
    });
  }
}


Future<void> uploadImages() async {
  try {
    // Loop over each image and send it one by one
    for (var i = 0; i < _images.length; i++) {
      // Create a multipart request for the current image
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/prescription/${order.id}/'),
      );

      // Get the current image
      var image = _images[i];

      // Attach the file
      var stream = http.ByteStream(File(image.path).openRead());
      var length = await File(image.path).length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: p.basename(image.path),
      );
      request.files.add(multipartFile);

      // Send the multipart request for the current image
      var imageResponse = await request.send();
      var imageResponseBody = await http.Response.fromStream(imageResponse);

      print('Image upload response status: ${imageResponse.statusCode}');
      print('Image upload response body: ${imageResponseBody.body}');

      if (imageResponse.statusCode == 200) {
        print('Image ${i + 1} uploaded successfully.');
      } else {
        print('Failed to upload image ${i + 1}: ${imageResponse.statusCode}');
        print('Failed to upload image ${i + 1} response: ${imageResponseBody.body}');
      }
    }
  } catch (e) {
    print('Error uploading images: $e');
  }
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

Future<void> reorderProduct() async {
  print("Starting reorder process");

  try {
    final List<Medicine1> medicines = await fetchMedicinesFromApi();
    print(medicines[1].name);

    // Initialize the list to store matched medicine details
    final List<Medicine> matchedData = [];

    // Iterate through the order items and match with medicines
    for (var item in order.items) {
      final matchedMedicine = medicines.firstWhere((medicine) => medicine.id == item.id);
      if (matchedMedicine != null) {
        matchedData.add(Medicine(
          company: matchedMedicine.company,
          id: item.id,
          name: matchedMedicine.name,
          price: matchedMedicine.price,
          quantity: item.quantity, // Assuming quantity is a property of the item
        ));
      }
    }

    // Navigate to the ItemDetailsPage with the matched data
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(
          medicalDetails: matchedData,
        ),
      ),
    );

    // Print the matched data for debugging purposes
    print("Matched Data:");
    print(matchedData);

    // Display the matched data in a table
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reorder Products'),
          content: SizedBox(
            width: double.maxFinite,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Product ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Quantity')),
              ],
              rows: matchedData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data.id.toString())),
                  DataCell(Text(data.name)),
                  DataCell(Text(data.price.toString())),
                  DataCell(Text(data.quantity.toString())),
                ]);
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error in reorderProduct: $e');
  }
}
Future<List<Medicine1>> fetchMedicinesFromApi() async {
  try {
    // Simulate fetching data from an API
    
   final response = await http
        .get(Uri.parse('http://${Pallete.ipaddress}:8080/api/products'));
    
    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> data = jsonDecode(response.body);

      // Convert the JSON list to a list of Medicine1 objects
      List<Medicine1> medicines = data.map((json) => Medicine1.fromJson(json)).toList();

      return medicines;
    } else {
      throw Exception('Failed to load medicines');
    }
  } catch (e) {
    // Handle any errors that occur during the fetch
    print("Error fetching medicines: $e");
    throw Exception('Error fetching medicines');
  }
}



}

