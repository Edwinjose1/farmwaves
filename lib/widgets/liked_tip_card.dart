

import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/description_screen.dart';
import 'package:flutter_application_0/liked/bloc/liked_bloc.dart';

import 'package:flutter_application_0/model/healthtipdatamodel.dart';

class LikedtileWidget extends StatelessWidget {
  final HealthTipDataModel healthTipDataModel;
  final String id;
  final String heading;
  final String description;
  final String imageUrl;
  final LikedBloc likedBloc;

  const LikedtileWidget({
    Key? key,
    required this.healthTipDataModel,
    required this.likedBloc,
    required this.id,
    required this.heading,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(
              id: id,
              heading: heading,
              description: description,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Set the circular radius here
              child: Container(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                heading,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, size: 20),
                  onPressed: () {
                
                    // Handle like action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment, size: 20),
                  onPressed: () {
                    // Handle comment action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, size: 20),
                  onPressed: () {
                    // Handle share action
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
