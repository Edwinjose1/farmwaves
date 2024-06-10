import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/comment.dart';
import 'package:flutter_application_0/Screens/description_screen.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/model/healthtipdatamodel.dart';

class HealthTipItem extends StatefulWidget {
  final HealthTipDataModel healthTipDataModel;
  final HomeBloc homeBloc;
  final String id;
  final String heading;
  final String description;
  final String imageUrl;

  const HealthTipItem({
    Key? key,
    required this.healthTipDataModel,
    required this.homeBloc,
    required this.id,
    required this.heading,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HealthTipItemState createState() => _HealthTipItemState();
}

class _HealthTipItemState extends State<HealthTipItem> {
  bool _isExpanded = false; // Initially collapsed
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(
              id: widget.id,
              heading: widget.heading,
              description: widget.description,
              imageUrl: widget.imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .25,
              width: double.infinity,
              color: const Color.fromARGB(255, 173, 173, 173),
              child: Center(
                child: Image.asset(
                  widget.imageUrl,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.heading,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10.0),
            // Use maxLines property to limit the display to maximum 4 or 6 lines based on _isExpanded
            Text(
              widget.description,
              style: const TextStyle(color: Colors.black),
              maxLines: _isExpanded ? 6 : 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10.0),
            if (widget.description.length > 100) // Show 'See More' button if description length exceeds 100 characters
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'See Less' : 'See More',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            const SizedBox(height: 10.0),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_sharp,
                        color: _isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked; // Toggle the liked state
                        });
                      
                      },
                    ),
                    const Text(
                      '110',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => CommentPage(),
                        );
                      },
                    ),
                    const Text(
                      '23',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
