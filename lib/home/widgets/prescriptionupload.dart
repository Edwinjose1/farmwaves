import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/prescriptiondetailsonhomescreen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';


class ImageUploading extends StatelessWidget {
  const ImageUploading({
    Key? key,
    required this.homeBloc,
  }) : super(key: key);

  final HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: GestureDetector(
        onTap: () {
          // Navigate to PrescriptionFormfield screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrescriptionFormfield()),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: double.infinity,
          color: Color.fromARGB(255, 225, 225, 228),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
