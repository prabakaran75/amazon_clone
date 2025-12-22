import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStar extends StatelessWidget {
  final double ratings;
  const RatingStar({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 18,
      rating: ratings,
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    );
  }
}
