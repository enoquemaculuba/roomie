// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:roomie/pages/near_more.dart';
import 'package:roomie/pages/recommendation_more.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/util/places.dart';
import 'package:roomie/widgets/util.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Koti',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MainPage> {
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

  List<PlaceCard> recommendations = recommended();
  List<PlaceCard> near = nearby();

  bool first = true;

  final List<CategoryButton> _categoryButtons = [
    CategoryButton('Saunatilat'),
    CategoryButton('Juhlatilat'),
    CategoryButton('Liikuntatilat'),
    CategoryButton('Työtilat'),
    CategoryButton('Varastotilat'),
    CategoryButton('Mökit')
  ];

  void reloadState() {
    setState(() {});
  }

  TimeRange timeRange = TimeRange(DateTime.now(), DateTime.now());

  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      recommendations.shuffle();
      near.shuffle();
    }
    List<Widget> categoryButtons = [];

    for (CategoryButton i in _categoryButtons) {
      i.f = reload;
      categoryButtons.add(i.create());
    }

    return ListView(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: SearchBar(
              _categoryButtons,
              text: 'Etsi itsellesi sopivin tila...',
              searchFrom: services(),
            )),
        Center(
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[for (Widget child in categoryButtons) child],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 300,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: timeRangeWidget(context, reloadState, timeRange)),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Divider(color: Colors.grey[500]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text(
                'Suosituksemme sinulle',
                style: Styles.textBold,
              ),
              AddButton(page: RecommendationPage())
            ],
          ),
        ),
        SizedBox(
          width: 400,
          height: 230,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for (PlaceCard child in recommendations)
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: placeClick(child, context))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text(
                'Lähellä sinua',
                style: Styles.textBold,
              ),
              AddButton(page: NearPage())
            ],
          ),
        ),
        SizedBox(
          width: 400,
          height: 230,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for (PlaceCard child in near)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: placeClick(child, context),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget timeRangeWidget(BuildContext context, Function f, TimeRange timeRange) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('Valittu aikaväli', style: Styles.placeH2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              timePick(context, timeRange, true, f),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: timePick(context, timeRange, false, f),
              )
            ],
          ),
        ]),
  );
}

class TimeRange {
  DateTime startTime;
  DateTime endTime;
  TimeRange(this.startTime, this.endTime);
}

String getDay(int day) {
  if (day == 1) {
    return "maanantai";
  } else if (day == 2) {
    return 'tiistai';
  } else if (day == 3) {
    return 'keskiviikko';
  } else if (day == 4) {
    return 'torstai';
  } else if (day == 5) {
    return 'perjantai';
  } else if (day == 6) {
    return 'lauantai';
  } else {
    return 'sunnuntai';
  }
}

Future<void> _selectDate(
    BuildContext context, TimeRange timeRange, bool isStart, Function f) async {
  var selectedDate = isStart ? timeRange.startTime : timeRange.endTime;
  var picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2015, 8),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
          data: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)),
          child: child!);
    },
  );
  if (picked != null && picked != selectedDate) {
    isStart ? timeRange.startTime = picked : timeRange.endTime = picked;
    f();
    debugPrint("selected ${timeRange.startTime}");
  }
}

Widget timePick(
    BuildContext context, TimeRange timeRange, bool isStart, Function f) {
  final format = DateFormat('dd.MM');
  var style = TextStyle(color: Colors.white);
  return InkWell(
    onTap: () => {
      _selectDate(context, timeRange, isStart, f),
    },
    child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Styles.primaryRed,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
              ),
              isStart
                  ? Text(
                      "${getDay(timeRange.startTime.weekday)} ${format.format(timeRange.startTime)}",
                      style: style)
                  : Text(
                      "${getDay(timeRange.endTime.weekday)} ${format.format(timeRange.endTime)}",
                      style: style)
            ],
          ),
        )),
  );
}
