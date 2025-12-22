import 'package:amazon_clone/constant/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarousalImage extends StatelessWidget {
  const CarousalImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages.map((e) {
        return Builder(
          builder: (context) => Image.network(
            e,
            fit: BoxFit.cover,
            // height: Dimensions.height(context) * 0.2,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: Dimensions.height(context) * 0.26,
      ),
    );
  }
}
