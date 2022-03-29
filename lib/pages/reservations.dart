// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/util/DatabaseHelper.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:roomie/widgets/util.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(name: 'Varaukset', context: context),
      body: const ReservationsMain(),
    );
  }
}

class ReservationsMain extends StatelessWidget {
  const ReservationsMain({Key? key}) : super(key: key);

  Future<List<PlaceWrapper>> getList() async {
    return await DatabaseHelper.instance.placeToPlaceWrapper();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: FutureBuilder<List<PlaceWrapper>>(
          future: getList(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var now = DateTime.now();
              var upcomming = [];
              var past = [];
              for (PlaceWrapper wrapper in snapshot.data!.toList()) {
                var startTime = wrapper.startTime!;
                var endTime = wrapper.endTime!;
                if (now.difference(startTime).isNegative) {
                  upcomming.add(wrapper);
                } else if (endTime.difference(now).isNegative) {
                  past.add(wrapper);
                } else {
                  upcomming.add(wrapper);
                }
              }
              return ListView(
                children: [
                  if (upcomming.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('Käynnissä olevat varaukseni',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    for (PlaceWrapper wrapper in upcomming)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: reservesPlaceClick(
                            wrapper, card(wrapper, false), context),
                      )
                  ],
                  if (past.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('Menneet varaukset',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    for (PlaceWrapper wrapper in past)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: reservesPlaceClick(
                            wrapper, card(wrapper, true), context),
                      )
                  ],
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/pic1.PNG'),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Sinulla ei ole vielä varauksia'),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

String getMonth(int month) {
  if (month == 1) {
    return 'tammi';
  } else if (month == 2) {
    return 'helmi';
  } else if (month == 3) {
    return 'maalis';
  } else if (month == 4) {
    return 'huhti';
  } else if (month == 5) {
    return 'touko';
  } else if (month == 6) {
    return 'kesä';
  } else if (month == 7) {
    return 'heinä';
  } else if (month == 8) {
    return 'elo';
  } else if (month == 9) {
    return 'syys';
  } else if (month == 10) {
    return 'loka';
  } else if (month == 11) {
    return 'marras';
  } else {
    return 'joulu';
  }
}

Widget card(PlaceWrapper placeWrapper, bool old) {
  PlaceCard place = placeWrapper.placeCard;
  var startTime = placeWrapper.startTime!;
  var endTime = placeWrapper.endTime!;
  var textColor = old ? Colors.black : Colors.white;
  var numberColor = old ? Colors.grey[700] : Styles.primaryRed;
  return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: old ? Colors.grey[350] : Styles.primaryRed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(startTime.day.toString(),
                        style: TextStyle(
                            color: numberColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Text(getMonth(startTime.month),
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text(startTime.year.toString())
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(children: <Widget>[
                          Icon(Icons.location_on_outlined,
                              color: textColor, size: 20),
                          Text(place.address,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Row(children: <Widget>[
                        Icon(Icons.access_time_rounded,
                            color: textColor, size: 20),
                        isSameDate(startTime, endTime)
                            ? Text(
                                "${time.format(startTime)}-${time.format(endTime)} ${date.format(startTime)}",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))
                            : Text(
                                "${dateWithTime.format(startTime)} - ${dateWithTime.format(endTime)}",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                      ])
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ));
}
