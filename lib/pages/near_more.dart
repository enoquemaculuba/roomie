import 'package:flutter/material.dart';
import 'package:roomie/util/places.dart';
import 'package:roomie/widgets/util.dart';

class NearPage extends StatelessWidget {
  const NearPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: 'Lähellä sinua', context: context),
        body: const NearMain());
  }
}

class NearMain extends StatelessWidget {
  const NearMain({Key? key}) : super(key: key);

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
      children:
          nearby().map((e) => placeClick(e, context)).toList(), //new Cards()
      shrinkWrap: true,
    );
  }
}
