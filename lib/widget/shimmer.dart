import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class Shimmering extends StatelessWidget {
  const Shimmering({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 160, 207, 248),
        highlightColor: Colors.white,
        child: ListView.builder(
          itemBuilder: (context, index) => Container(
            child: Column(children: [
              ListTile(
                leading: const CircleAvatar(),
                title: Container(
                  width: double.infinity,
                  height: 15,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                height: 40,
                color: Colors.white,
              ),
            ]),
          ),
          itemCount: 5,
        ));
    ;
  }
}
