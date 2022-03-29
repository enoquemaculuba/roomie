// ignore_for_file: camel_case_types, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomie/main.dart';
import 'package:roomie/pages/favorites.dart';
import 'package:roomie/pages/filters.dart';
import 'package:roomie/pages/home.dart';
import 'package:roomie/pages/near_more.dart';
import 'package:roomie/pages/reservation_page.dart';
import 'package:roomie/pages/reservations.dart';
import 'package:roomie/pages/search_page.dart';
import 'package:roomie/pages/settings.dart';
import 'package:roomie/pages/space.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:roomie/util/services.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

import 'package:roomie/util/globals.dart' as globals;

String dataName = 'data';

DateFormat mainFormatter = DateFormat('yyyy-MM-dd H:mm');

final format = DateFormat('dd-MM-yyyy H:mm');
final time = DateFormat('H:mm');
final date = DateFormat('dd.MM.yyyy');
final dateWithTime = DateFormat('dd.MM.yyyy HH:mm');

bool isSameDate(DateTime start, DateTime end) {
  return start.day == end.day &&
      start.year == end.year &&
      start.month == end.month;
}

extension MyDateUtils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

class AppBarMain extends AppBar {
  final String name;
  final BuildContext context;

  AppBarMain({Key? key, required this.name, required this.context})
      : super(
          key: key,
          centerTitle: true,
          title: Text(
            name,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 26.0,
              color: Colors.pink[600],
            ),
            onPressed: () {
              void change(Widget page) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => page));
              }

              // TODO fix new page error
              if (!ModalRoute.of(context)!.isFirst) {
                Navigator.pop(context);
              } else {
                if (globals.pageQueue.isNotEmpty) {
                  globals.pageQueue.removeFirst();
                  if (globals.pageQueue.isNotEmpty) {
                    switch (globals.pageQueue.first) {
                      case 'home':
                        change(const MyApp());
                        break;
                      case 'reservations':
                        change(const MyApp());
                        break;
                      case 'favorites':
                        change(const MyApp());
                        break;
                      case 'settings':
                        change(const MyApp());
                        break;
                    }
                  } else {
                    change(const MyApp());
                  }
                } else {
                  change(const MyApp());
                }
              }
              /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );*/
            },
          ),
          /* actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.lock_outlined,
                      size: 26.0,
                      color: Colors.pink[600],
                    ),
                  )),
            ]*/
        );
}

class AddButton extends StatelessWidget {
  final Widget page;
  const AddButton({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: const Text(
        "lisää",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        primary: Styles.primaryRed,
        shadowColor: Colors.transparent,
        shape: const StadiumBorder(),
      ),
    );
  }
}

class CategoryButton {
  bool isSelected = false;
  final String text;
  late Function f;
  CategoryButton(this.text);
  create() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: ElevatedButton(
        onPressed: () {
          f(text);
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check : Icons.close,
                color: isSelected ? Styles.primaryRed : Colors.grey,
                size: 22.0,
              ),
              SizedBox(width: 4),
              Text(text,
                  style: TextStyle(
                      color: isSelected ? Styles.primaryRed : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
          side: BorderSide(
              color: isSelected ? Styles.primaryRed : Colors.grey, width: 2),
        ),
      ),
    );
  }
}

Widget placeClick(PlaceCard card, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SpacePage(
                  place: card,
                )),
      );
    },
    child: card,
  );
}

Widget reservesPlaceClick(
    PlaceWrapper placeWrapper, Widget card, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReservationPage(
                  place: placeWrapper,
                )),
      );
    },
    child: card,
  );
}

class ReservationTuple {
  final String start;
  final String end;
  ReservationTuple(this.start, this.end);
}

class PlaceCard extends StatelessWidget {
  final String name;
  final String type;
  final String adequacy;
  final String city;
  final String image;
  final int price;
  final String address;
  final String time;
  final List<ReservationTuple> reservations;
  final String info;
  final String usageInfo;
  final List<Service> services;

  const PlaceCard(
      {Key? key,
      required this.name,
      required this.type,
      required this.adequacy,
      required this.city,
      required this.image,
      required this.price,
      required this.address,
      required this.time,
      required this.reservations,
      this.services = const [],
      this.info = '',
      this.usageInfo = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String end = type == 'Mökki' || type == 'Varastotila' ? '/vrk' : '/h';
    return Card(
      color: Colors.black,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Container(
        height: 210,
        width: 160,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.dstATop),
            /*colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.srcOver),*/
            image: AssetImage('assets/image/' + image),
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(name, style: Styles.cardH1)),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(type, style: Styles.cardH2),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child:
                      Text('Sopivuus ' + adequacy + '%', style: Styles.cardH3),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(children: <Widget>[
                    const Icon(Icons.location_on_outlined,
                        color: Colors.white, size: 10),
                    Text(city, style: Styles.cardH3),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child:
                        Text(price.toString() + '€$end', style: Styles.cardH1),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final String text;
  final List<PlaceCard> searchFrom;
  final List<CategoryButton>? categories;

  const SearchBar(
    this.categories, {
    Key? key,
    required this.text,
    required this.searchFrom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (String value) {
        debugPrint('object submitted' + value);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage(
                  searchString: value,
                  searchFrom: searchFrom,
                  categories: categories)),
        );
      },
      decoration: InputDecoration(
        filled: true,
        hoverColor: Colors.white,
        fillColor: Colors.grey[300],
        prefixIcon: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(
              Icons.search_rounded,
              size: 40,
              color: Colors.grey[500],
            ),
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FilterPage()));
            },
            icon: Icon(Icons.tune, size: 30),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: text,
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final String text;
  const CustomSwitch({Key? key, required this.text}) : super(key: key);

  @override
  State<CustomSwitch> createState() => SwitchStateful();
}

class SwitchStateful extends State<CustomSwitch> {
  bool notificationsOn = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.text,
        style: const TextStyle(fontSize: 15),
      ),
      leading: Transform.scale(
        scale: 1.2,
        child: Switch(
            activeColor: Styles.primaryRed,
            value: notificationsOn,
            onChanged: (value) {
              setState(() {
                notificationsOn = value;
              });
            }),
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  State<CustomSlider> createState() => SliderStateful();
}

class SliderStateful extends State<CustomSlider> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Styles.primaryRed,
            inactiveTrackColor: Colors.pink.shade100,
            trackShape: const RoundedRectSliderTrackShape(),
            trackHeight: 5,
            thumbColor: Styles.primaryRed,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayColor: Colors.red.withAlpha(32),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
          ),
          child: Slider(
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          Text('Ei kiinnosta'),
          Text('Kiinnostaa'),
        ],
      )
    ]);
  }
}

class filterSlider extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final String unit;
  const filterSlider(
      {Key? key,
      required this.minValue,
      required this.maxValue,
      required this.unit})
      : super(key: key);

  @override
  State<filterSlider> createState() => filterStateful();
}

class filterStateful extends State<filterSlider> {
  RangeValues? _values; //TODO: change 100 to maxvalue
  @override
  void initState() {
    super.initState();
    if (widget.unit == '€') {
      _values =
          RangeValues(globals.minPrice.toDouble(), globals.maxPrice.toDouble());
    } else {
      _values =
          RangeValues(widget.minValue.toDouble(), widget.maxValue.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    var values = _values!;
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(((values.start.round()).toString() + ' ' + widget.unit),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              activeTrackColor: Styles.primaryRed,
              inactiveTrackColor: Colors.pink.shade100,
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 5,
              thumbColor: Styles.primaryRed,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
              showValueIndicator: ShowValueIndicator.never),
          child: RangeSlider(
            labels: RangeLabels(values.start.toString(), values.end.toString()),
            min: widget.minValue.toDouble(),
            max: widget.maxValue.toDouble(),
            divisions: widget.maxValue,
            values: values,
            onChanged: (values) {
              setState(() {
                if (widget.unit == '€') {
                  globals.minPrice = values.start.toInt();
                  globals.maxPrice = values.end.toInt();
                }
                _values = values;
              });
            },
          ),
        ),
        Text(((values.end.round()).toString() + ' ' + widget.unit),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
      ]),
    ]);
  }
}
