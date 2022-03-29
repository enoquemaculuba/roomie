import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:roomie/pages/buy_page.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:intl/intl.dart';

import 'package:roomie/widgets/util.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

import '../styles.dart';

DateFormat timeFormat = DateFormat('H:mm');

class ReservePage extends StatelessWidget {
  final PlaceWrapper place;
  const ReservePage({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: place.placeCard.name, context: context),
        backgroundColor: Colors.black,
        body: ReserveStateful(
          place: place,
        ));
  }
}

class ReserveStateful extends StatefulWidget {
  final PlaceWrapper place;
  const ReserveStateful({Key? key, required this.place}) : super(key: key);

  @override
  State<ReserveStateful> createState() => ReserveState();
}

List<String> times = [
  '00:00',
  '01:00',
  '02:00',
  '03:00',
  '04:00',
  '05:00',
  '06:00',
  '07:00',
  '08:00',
  '09:00',
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '18:00',
  '19:00',
  '20:00',
  '21:00',
  '22:00',
  '23:00',
];

class ReserveState extends State<ReserveStateful> {
  RichText type(String name, Color color) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(Icons.circle, size: 6, color: color),
          ),
          TextSpan(
            style: const TextStyle(color: Colors.black),
            text: ' ' + name,
          ),
        ],
      ),
    );
  }

  String startTime = times.first;
  String endTime = times[1];

  DateTime now = DateTime.now();
  DateTime? _currentDate;
  void refresh(DateTime date) {
    _currentDate = date;
  }

  String format(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date).toString();
  }

  List<String> timeList = [];

  DateTime? selectedStart;
  DateTime? selectedEnd;

// TODO: create list that has time and day so we can have reservations that end the next day or some day in future. Maybe map could work here
  DropdownButton dropDown(String date, PlaceWrapper placeWrapper, bool start) {
    String value = start ? startTime : endTime;
    return DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Styles.primaryRed),
        underline: Container(height: 2, color: Styles.primaryRed),
        onChanged: (String? newValue) {
          setState(() {
            start ? startTime = newValue! : endTime = newValue!;
            value = start ? startTime : endTime;
            var d = timeFormat.parse(value);
            start
                ? placeWrapper.startTime = placeWrapper.startTime!
                    .copyWith(hour: d.hour, minute: d.minute)
                : placeWrapper.endTime = placeWrapper.endTime!
                    .copyWith(hour: d.hour, minute: d.minute);
            var range = placeWrapper.startTime!
                .difference(placeWrapper.endTime!)
                .inHours
                .abs();
            selectedEnd = d;
            selectedStart = d;
            var placeType = placeWrapper.placeCard.type;
            if (placeType != 'Mökki' && placeType != 'Varastotila') {
              placeWrapper.totalPrice = placeWrapper.placeCard.price * range;
            }

            debugPrint("time is ${placeWrapper.startTime}");
          });
        },
        items: timeList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList());
  }

  MultipleMarkedDates multipleMarkedDates =
      MultipleMarkedDates(markedDates: []);

  bool once = false;

  @override
  Widget build(BuildContext context) {
    PlaceWrapper placeWrapper = widget.place;
    if (!once) {
      once = true;
      var time = placeWrapper.placeCard.time.split('-');
      var startIndex = times.indexOf("${time.first}:00");
      var endIndex = times.indexOf("${time.last}:00");
      timeList = times;
      if (startIndex < endIndex) {
        timeList = times.sublist(startIndex, endIndex + 1).toSet().toList();
      } else {
        timeList = (timeList.sublist(startIndex, times.length) +
                times.sublist(0, endIndex + 1))
            .toSet()
            .toList();
      }
      if (!timeList.contains(startTime)) {
        startTime = timeList.first;
      }
      if (!timeList.contains(endTime)) {
        endTime = timeList[1];
      }

      var start = timeFormat.parse(startTime);
      var end = timeFormat.parse(endTime);
      placeWrapper.startTime =
          now.copyWith(hour: start.hour, minute: start.minute);
      placeWrapper.endTime = now.copyWith(hour: end.hour, minute: end.minute);
    }
    String placeType = widget.place.placeCard.type;
    //TODO make it web friendly (add this to container like the rest pages are implemented)
    return ListView(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Center(
              child: Container(
                width: 370,
                child: Column(
                  children: [
                    CalendarCarousel<Event>(
                      onDayPressed: (DateTime date, List<Event> events) {
                        debugPrint('day' +
                            DateFormat('dd-MM-yyyy').format(date).toString());
                        setState(() {
                          multipleMarkedDates =
                              MultipleMarkedDates(markedDates: []);

                          f() {
                            var s = selectedStart ??
                                timeFormat.parse(timeList.first);
                            var e =
                                selectedEnd ?? timeFormat.parse(timeList[1]);
                            placeWrapper.startTime =
                                date.copyWith(hour: s.hour, minute: s.minute);
                            placeWrapper.endTime =
                                date.copyWith(hour: e.hour, minute: e.minute);
                            _currentDate = date;
                          }

                          if (date == _currentDate) {
                            placeWrapper.totalPrice = 0;
                            _currentDate = null;
                            widget.place.startTime = null;
                            widget.place.endTime = null;
                          } else {
                            placeWrapper.totalPrice =
                                placeWrapper.placeCard.price;
                            if (_currentDate == null) {
                              if (placeWrapper.startTime != null &&
                                  placeWrapper.endTime != null) {
                                refresh(date);
                                placeWrapper.startTime = placeWrapper.startTime!
                                    .copyWith(
                                        day: date.day,
                                        month: date.month,
                                        year: date.year);
                                placeWrapper.endTime = placeWrapper.endTime!
                                    .copyWith(
                                        day: date.day,
                                        month: date.month,
                                        year: date.year);
                              } else {
                                f();
                              }
                            } else if (placeType == 'Mökki' ||
                                placeType == 'Varastotila') {
                              var range = date.difference(_currentDate!).inDays;
                              if (range > 0) {
                                placeWrapper.totalPrice =
                                    placeWrapper.placeCard.price * (range + 1);

                                widget.place.startTime = _currentDate;
                                widget.place.endTime = date;

                                multipleMarkedDates.addRange(
                                    MarkedDate(
                                        date: _currentDate!,
                                        color: Styles.primaryRed),
                                    plus: range);
                              }
                            } else {
                              f();
                            }
                          }
                        });
                      },
                      multipleMarkedDates:
                          placeType == 'Mökki' || placeType == 'Varastotila'
                              ? multipleMarkedDates
                              : null,
                      weekendTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      thisMonthDayBorderColor: Colors.transparent,
                      firstDayOfWeek: 1,
                      headerTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      leftButtonIcon: Icon(
                        Icons.keyboard_arrow_left_outlined,
                        size: 30.0,
                        color: Colors.pink[600],
                      ),
                      rightButtonIcon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 30.0,
                        color: Colors.pink[600],
                      ),
                      weekDayFormat: WeekdayFormat.narrow,
                      minSelectedDate:
                          DateTime.now().subtract(const Duration(days: 1)),
                      todayButtonColor: Colors.pink.shade100,
                      todayBorderColor: Colors.transparent,
                      weekdayTextStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
                      selectedDayButtonColor: Styles.primaryRed,
                      selectedDayBorderColor: Colors.transparent,

                      /*customDayBuilder: (
                        /// you can provide your own build function to make custom day containers
                        bool isSelectable,
                        int index,
                        bool isSelectedDay,
                        bool isToday,
                        bool isPrevMonthDay,
                        TextStyle textStyle,
                        bool isNextMonthDay,
                        bool isThisMonthDay,
                        DateTime day,
                      ) {
                        /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                        /// This way you can build custom containers for specific days only, leaving rest as default.

                        // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                        if (day.day == 28) {
                          return const Center(
                            child: Icon(Icons.local_airport),
                          );
                        } else {
                          // return null;
                        }
                      },*/
                      weekFormat: false,
                      height: 420.0,
                      selectedDateTime: _currentDate,
                      daysHaveCircularBorder: true,

                      /// null for not rendering any border, true for circular border, false for rectangular border
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50, right: 50, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          type('Vapaa', Colors.black),
                          type('Varattu', Colors.grey),
                          type('Valittu', Styles.primaryRed)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Aloitusaika',
                                style: TextStyle(color: Colors.grey),
                              ),
                              dropDown(format(_currentDate ?? now),
                                  widget.place, true),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Lopetusaika',
                                  style: TextStyle(color: Colors.grey)),
                              dropDown(format(_currentDate ?? now),
                                  widget.place, false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Text(
                          'Kokonaishinta: ${widget.place.getTotalPrice()}€',
                          style: Styles.placeH1,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if (_currentDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Valitse edes yksi päivä"),
                  ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BuyPage(
                              place: widget.place,
                            )),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Styles.primaryRed,
                  fixedSize: const Size(280, 60),
                  shape: const StadiumBorder()),
              child: const Text('Siirry maksamaan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }
}
