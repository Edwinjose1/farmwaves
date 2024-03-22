import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/chat_screen.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/home/widgets/bottomsheet.dart';
import 'package:flutter_application_0/home/widgets/card_tip.dart';
import 'package:flutter_application_0/home/widgets/image_preview.dart';
import 'package:flutter_application_0/home/widgets/main_heading.dart';
import 'package:flutter_application_0/liked/ui/liked_tips_Screen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/search/ui/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home1 extends StatefulWidget {
  const Home1({Key? key}) : super(key: key);

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  late HomeBloc homeBloc;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc()..add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeSearchState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  SearchScreen()),
          );
        } else if (state is HomeTipsLikedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'Liked a Tip',
              style: TextStyle(color: Colors.white),
            ),
          ));
        } else if (state is LikeditemPageNavigateActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Liked()),
          );
        } else if (state is UploadprescriptionActionstate) {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return BottomsheetTakingimage(
                onImageSelected: (image) {
                  setState(() {
                    selectedImage = image;
                    homeBloc.add(ImageshowingPageEvent());
                  });
                },
              );
            },
          );
        } else if (state is ImageshowingPageActionstate) {
          showImagePreviewAndSubmit(context, selectedImage!);
        }
      },
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is HomeLoadedSuccessState) {
          // ignore: unnecessary_cast
          final successState = state as HomeLoadedSuccessState;
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 237, 239, 245),
              body: Column(
                children: [
                  // Static container with 1/3 of screen height
                  MainHeading(homeBloc: homeBloc),
            
                  // Scrollable container with remaining space
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          successState.tipslists.length,
                          (index) {
                            final tip = successState.tipslists[index];
            
                            return HealthTipItem(
                              healthTipDataModel: tip,
                              homeBloc: homeBloc,
                              id: tip.id,
                              heading: tip.heading,
                              description: tip.description,
                              imageUrl: tip.imageUrl,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Pallete.darkgreenColor,
                child: const Icon(Icons.message_rounded,color: Color.fromARGB(255, 179, 178, 178),),
                onPressed: () {
    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ChatPage()),
          );


                },
              ),
            ),
          );
        } else {
          return Container(); // Return an empty container if state is not recognized
        }
      },
    );
  }
}
