import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';

class Headpart extends StatelessWidget {
  const Headpart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height:MediaQuery.of(context).size.height * 0.10, 
      width: double.infinity,
      color: Pallete.greenColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Container(
                height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.3, color: Colors.white),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Search here.....',
                          style:
                              TextStyle(color: Colors.white),
                        ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Icon(
                          Icons.search_sharp,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
