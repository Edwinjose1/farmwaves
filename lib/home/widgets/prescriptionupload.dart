import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';

class ImageUploading extends StatelessWidget {
  const ImageUploading({
    Key? key,
    required this.homeBloc,
    this.comingSoon = true,
  }) : super(key: key);

  final HomeBloc homeBloc;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Show the bottom sheet for selecting image
              if (!comingSoon) {
                homeBloc.add(UploadPrescriptionEvent());
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10, 
              width: double.infinity,
              color: comingSoon ? const Color.fromARGB(24, 224, 224, 224) : const Color.fromARGB(255, 65, 65, 66),
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
          if (comingSoon)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: const Color.fromARGB(255, 65, 64, 64).withOpacity(0.7),
                alignment: Alignment.center,
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20,fontWeight: FontWeight.w500),
                ),
              ),
            ),
          if (comingSoon)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(),
              ),
            ),
        ],
      ),
    );
  }
}
