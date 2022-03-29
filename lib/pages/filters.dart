// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:roomie/main.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/widgets/util.dart';

List<bool> limitSelection = [false, false, true];

final List<CategoryButton> _categoryButtons = [
  CategoryButton('Saunatilat'),
  CategoryButton('Juhlatilat'),
  CategoryButton('Liikuntatilat'),
  CategoryButton('Työtilat'),
  CategoryButton('Varastotilat'),
  CategoryButton('Mökit')
];

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(name: 'Filtterit', context: context),
      body: const Filter(),
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => FilterStateful();
}

class FilterStateful extends State<Filter> {
  bool notificationsOn = false;

  //RangeValues _priceRangeValues = const RangeValues(0, 600);
  CategoryButton saunatilat = CategoryButton("Saunatilat");
  CategoryButton juhlatilat = CategoryButton("Juhlatilat");
  CategoryButton liikuntatilat = CategoryButton("Liikuntatilat");
  CategoryButton tyotilat = CategoryButton("Työtilat");
  CategoryButton varastotilat = CategoryButton("Varastotilat");
  CategoryButton mokit = CategoryButton("Mökit");

  void reload(String name) {
    setState(() {
      for (CategoryButton category in _categoryButtons) {
        if (category.text == name) {
          category.isSelected = !category.isSelected;
        } else {
          category.isSelected = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    saunatilat.f = reload;
    juhlatilat.f = reload;
    liikuntatilat.f = reload;
    tyotilat.f = reload;
    varastotilat.f = reload;
    mokit.f = reload;
    List<Widget> widgets = [
      /*Text('Kategoriat',
          style: Styles
              .textBold //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
          ),
      SizedBox(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Column(children: [
                Row(children: [saunatilat.create(), juhlatilat.create()]),
                Row(children: [liikuntatilat.create(), tyotilat.create()]),
                Row(children: [varastotilat.create(), mokit.create()])
              ])
            ],
          ),
        ),
      ),*/
      Text('Hinta', style: Styles.textBold),
      filterSlider(minValue: 0, maxValue: 600, unit: '€'),
      Text('Kapasiteetti', style: Styles.textBold),
      filterSlider(minValue: 0, maxValue: 200, unit: 'hlö'),
      Text('Etäisyys', style: Styles.textBold),
      filterSlider(minValue: 0, maxValue: 100, unit: 'km'),
      Text('Hakutulosten määrä sivulla', style: Styles.textBold),
      Row(
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: ToggleButtons(
              highlightColor: Colors.white,
              fillColor: Colors.white12,
              splashColor: Colors.white12,
              color: Colors.grey,
              selectedColor: Styles.primaryRed,
              selectedBorderColor: Styles.primaryRed,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              renderBorder: false,
              constraints: BoxConstraints(maxWidth: 40, minWidth: 30),
              children: <Widget>[
                Icon(limitSelection[0] ? Icons.circle : Icons.circle_outlined,
                    size: 22),
                Icon(limitSelection[1] ? Icons.circle : Icons.circle_outlined,
                    size: 22),
                Icon(limitSelection[2] ? Icons.circle : Icons.circle_outlined,
                    size: 22),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int indexBtn = 0;
                      indexBtn < limitSelection.length;
                      indexBtn++) {
                    if (indexBtn == index) {
                      if (!limitSelection[indexBtn]) {
                        limitSelection[indexBtn] = !limitSelection[indexBtn];
                      }
                    } else {
                      limitSelection[indexBtn] = false;
                    }
                  }
                });
              },
              isSelected: limitSelection,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '20',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Text('50',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(height: 9),
                Text('Ei rajaa',
                    style: TextStyle(
                      fontSize: 18,
                    ))
              ],
            ),
          ),
        ],
      ),
      Divider(
        color: Colors.grey[500],
        thickness: 1,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
            child: Container(
              height: 40,
              width: 120,
              child: Center(
                child: const Text(
                  "Tallenna",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Styles.primaryRed,
              shadowColor: Colors.transparent,
              shape: const StadiumBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Container(
              height: 40,
              width: 120,
              child: Center(
                child: const Text(
                  "Nollaa kaikki",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Styles.primaryRed,
              shadowColor: Colors.transparent,
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
      SizedBox()
    ];
    return Center(
      child: SizedBox(
        width: 400,
        child: ListView(
          padding: const EdgeInsets.only(left: 30, right: 30),
          children: <Widget>[
            for (Widget w in widgets) addSpace(w, EdgeInsets.only(top: 15)),
          ],
        ),
      ),
    );
  }
}

Widget addSpace(Widget to, EdgeInsets padding) {
  return Padding(padding: padding, child: to);
}
