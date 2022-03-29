import 'package:flutter/material.dart';
import 'package:roomie/pages/process_payment.dart';
import 'package:roomie/roomie_icons.dart';
import 'package:roomie/util/DatabaseHelper.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:roomie/widgets/util.dart';
import 'package:intl/intl.dart';

import '../styles.dart';

DateFormat customFormat = DateFormat('dd.MM.yyyy H:mm');

class BuyPage extends StatelessWidget {
  final PlaceWrapper place;
  const BuyPage({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: 'Maksu', context: context),
        body: BuyMain(
          place: place,
        ));
  }
}

class BuyMain extends StatelessWidget {
  final PlaceWrapper place;
  const BuyMain({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: 400,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: w > 400 ? 400 : w,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/' + place.placeCard.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height - 350,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter,
                        colors: [
                          Colors.white,
                          Color.fromARGB(230, 255, 255, 255),
                        ],
                        stops: [
                          0.9,
                          1.0
                        ]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 280,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(place.placeCard.name,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold))),
                            Text(place.placeCard.address,
                                style: const TextStyle(fontSize: 15)),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("${place.getTotalPrice()}€",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Styles.primaryRed,
                                      fontWeight: FontWeight.bold)),
                            ),
                            if (place.startTime != null &&
                                place.endTime != null)
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                      "${customFormat.format(place.startTime!)} - ${customFormat.format(place.endTime!)}",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: payment(context, place, 'Maksa kortilla',
                            Icons.payment_outlined, 30)),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: payment(context, place, 'Goole Pay',
                            Icons.g_mobiledata_outlined, 40)),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: payment(
                            context, place, 'Mobilepay', Roomie.mobilepay, 30))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ElevatedButton payment(BuildContext context, PlaceWrapper place, String text,
    IconData icon, double size) {
  return ElevatedButton(
    onPressed: () {
      place.reservationTime =
          DateFormat('d-M-yyyy H:mm').format(DateTime.now()).toString();
      DatabaseHelper.instance.reservationToDb(place);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(name: place.placeCard.name)),
      );
    },
    style: ElevatedButton.styleFrom(
      primary: Styles.primaryRed,
      fixedSize: const Size(280, 60),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: Icon(
            icon,
            size: size,
          ),
        ),
        Text(text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
