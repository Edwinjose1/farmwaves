import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';

class ImageUploading extends StatelessWidget {
  const ImageUploading({
    super.key,
    required this.homeBloc,
  });

  final HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: GestureDetector(
        onTap: () {
          // Show the bottom sheet for selecting image
          homeBloc.add(UploadPrescriptionEvent());
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.10, 
          width: double.infinity,
          color: const Color.fromARGB(255, 237, 239, 245),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.black,
                ),
              ),
            
              const Text(
                'upload prescription here',
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
    );
  }
}

