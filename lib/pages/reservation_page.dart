import 'package:flutter/material.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/util/DatabaseHelper.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:roomie/util/services.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:roomie/widgets/util.dart';

class ReservationPage extends StatefulWidget {
  final PlaceWrapper place;
  final double width = 325;
  const ReservationPage({Key? key, required this.place}) : super(key: key);

  @override
  State<ReservationPage> createState() => ReservationStateful();
}

List<Service> parseService(String text) {
  List<List<String>> services =
      text.split(',').map((e) => e.split(':')).toList();
  return services
      .map((e) => Service(
          text: e[1],
          price: int.parse(e[0]),
          icon: IconData(int.parse(e[2]), fontFamily: 'MaterialIcons')))
      .toList();
}

class ReservationStateful extends State<ReservationPage> {
  int price = 0;
  @override
  Widget build(BuildContext context) {
    if (price == 0) {
      price = widget.place.price;
    }
    //initialDuration <= duration
    countdown(int leftTime, CountDownController controller, int wholeTime) {
      return CircularCountDownTimer(
        duration: leftTime + wholeTime,
        initialDuration: wholeTime,
        controller: controller,
        width: 200,
        height: 200,
        ringColor: Colors.pink[100] as Color,
        ringGradient: null,
        fillColor: Styles.primaryRed,
        fillGradient: null,
        backgroundColor: Colors.white,
        backgroundGradient: null,
        strokeWidth: 15.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: 33.0,
            color: Styles.primaryRed,
            fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.HH_MM_SS,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          debugPrint('Countdown Started');
        },
        onComplete: () {
          debugPrint('Countdown Ended');
          setState(() {});
        },
      );
    }

    PlaceWrapper placeWrapper = widget.place;
    PlaceCard place = placeWrapper.placeCard;
    DateTime start = placeWrapper.startTime!;
    DateTime end = placeWrapper.endTime!;
    DateTime reservationTime = format.parse(placeWrapper.reservationTime);

    var now = DateTime.now();
    var startDifference = start.difference(now);
    var endDifference = end.difference(now);
    var isAboutToStart = !startDifference.isNegative;
    var isAboutToEnd = !endDifference.isNegative;

    var endStartDifference = end.difference(start);
    var startReservationDifference = start.difference(reservationTime);

    CountDownController _controller = CountDownController();

    List<Service> services = [];
    if (placeWrapper.services.isNotEmpty) {
      services = parseService(placeWrapper.services);
    }

    return Scaffold(
        appBar: AppBarMain(name: place.name, context: context),
        body: Center(
          child: SizedBox(
            width: widget.width,
            child: Column(children: [
              Expanded(
                  child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                children: <Widget>[
                  Center(
                    child: Container(
                      height: widget.width,
                      width: widget.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        image: DecorationImage(
                          image: AssetImage('assets/image/' + place.image),
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: widget.width - 25,
                      child: Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  place.name,
                                  style: Styles.placeH1,
                                ),
                                Text(
                                  placeWrapper.price.toString() + '€',
                                  style: Styles.placeRedH1,
                                ),
                              ],
                            ),
                          ),
                          Text('Sopivuus ' + place.adequacy + '%',
                              style: TextStyle(color: Styles.primaryRed)),
                          Row(children: <Widget>[
                            const Icon(Icons.location_on_outlined,
                                color: Colors.black, size: 15),
                            Text(place.address + ', ' + place.city,
                                style: Styles.placeH2),
                          ]),
                          Row(children: <Widget>[
                            const Icon(Icons.access_time_outlined,
                                color: Colors.black, size: 15),
                            isSameDate(start, end)
                                ? Text(
                                    "${time.format(start)}-${time.format(end)} ${date.format(start)}",
                                    style: Styles.placeH2)
                                : Text(
                                    "${dateWithTime.format(start)} - ${dateWithTime.format(end)}",
                                    style: Styles.placeH2),
                          ]),
                          if (isAboutToStart) ...[
                            const Text('Aikaa varauksesi alkuun: ',
                                style: Styles.placeH1),
                            Center(
                                child: countdown(
                                    startDifference.inSeconds,
                                    _controller,
                                    startReservationDifference.inSeconds))
                          ],
                          if (!isAboutToStart && isAboutToEnd) ...[
                            const Text('Varauksesi päättyy:',
                                style: Styles.placeH1),
                            Center(
                                child: countdown(endDifference.inSeconds,
                                    _controller, endStartDifference.inSeconds))
                          ],
                          if (!isAboutToStart && !isAboutToEnd) ...[
                            const Text('Varauksesi on päättynyt',
                                style: Styles.placeH1),
                          ],
                          if (services.isNotEmpty) ...[
                            const Text('Valitsemasi lisäpalvelut',
                                style: Styles.placeH1),
                            for (Service service in services)
                              ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(service.text),
                                    Text(
                                      service.price.toString() + '€',
                                      style: TextStyle(
                                          color: Styles.primaryRed,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Styles.primaryRed,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Icon(service.icon,
                                        color: Colors.white, size: 30)),
                              )
                          ],
                          if (place.info != '') ...[
                            const Text('Tilan yleistiedot',
                                style: Styles.placeH1),
                            Text(place.info)
                          ],
                          if (place.usageInfo != '') ...[
                            const Text('Ohjeistus tilan käyttöön',
                                style: Styles.placeH1),
                            Text(place.usageInfo)
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              if (isAboutToStart) ...[
                Center(
                  child: SizedBox(
                    width: 400,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Varaus poistettu (toiminnallisuus puuttuu)"),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Styles.primaryRed,
                                  fixedSize: const Size(300, 60),
                                  shape: const StadiumBorder()),
                              child: const Text('Peru varauksesi',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ]),
          ),
        ));
  }
}
