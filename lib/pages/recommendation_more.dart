import 'package:flutter/material.dart';
import 'package:roomie/util/places.dart';
import 'package:roomie/widgets/util.dart';

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: 'Suosituksemme sinulle', context: context),
        body: const RecommendationMain());
  }
}

class RecommendationMain extends StatelessWidget {
  const RecommendationMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int widthCard = (200);
    int countRow = width ~/ widthCard;
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      crossAxisCount: countRow,
      childAspectRatio: 0.80,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: recommended().map((e) => placeClick(e, context)).toList(),
      shrinkWrap: true,
    );
  }
}
