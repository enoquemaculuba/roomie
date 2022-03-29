import 'package:flutter/material.dart';
import 'package:roomie/pages/reserve.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/util/DatabaseHelper.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:roomie/util/services.dart';

import 'package:roomie/widgets/util.dart';

import 'package:roomie/util/globals.dart' as globals;

class SpacePage extends StatefulWidget {
  final PlaceCard place;
  final double width = 325;
  const SpacePage({Key? key, required this.place}) : super(key: key);

  @override
  State<SpacePage> createState() => SpaceStateful();
}

class SpaceStateful extends State<SpacePage> {
  int price = 0;

  List<String> services = [];
  var favorite = false;

  @override
  Widget build(BuildContext context) {
    if (price == 0) {
      price = widget.place.price;
    }
    PlaceWrapper place = PlaceWrapper(placeCard: widget.place, totalPrice: 0);

    return Scaffold(
        appBar: AppBarMain(name: widget.place.name, context: context),
        body: Center(
          child: SizedBox(
            width: widget.width,
            child: Column(children: [
              Expanded(
                  child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          child: GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                favorite = !favorite;
                                if (!favorite) {
                                  DatabaseHelper.instance.deleteFavorite(
                                      "${widget.place.name}:${widget.place.address}");
                                } else {
                                  DatabaseHelper.instance.insertFavorite(
                                      "${widget.place.name}:${widget.place.address}");
                                }
                                debugPrint("favorite $favorite");
                              });
                            },
                          ),
                          height: widget.width,
                          width: widget.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40)),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/image/' + widget.place.image),
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        //TODO add a way to check if this place is in favorites. Need to access database and use futurebuilder
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: FutureBuilder<List<String>>(
                                    future: DatabaseHelper.instance
                                        .getFavorites(), // a previously-obtained Future<String> or null
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<String>> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.contains(
                                            "${widget.place.name}:${widget.place.address}")) {
                                          favorite = true;
                                        }
                                      }
                                      return RawMaterialButton(
                                          elevation: 2.0,
                                          shape: const CircleBorder(),
                                          fillColor: Colors.black,
                                          padding: const EdgeInsets.all(5),
                                          onPressed: () {
                                            setState(() {
                                              favorite = !favorite;
                                              if (!favorite) {
                                                DatabaseHelper.instance
                                                    .deleteFavorite(
                                                        "${widget.place.name}:${widget.place.address}");
                                              } else {
                                                DatabaseHelper.instance
                                                    .insertFavorite(
                                                        "${widget.place.name}:${widget.place.address}");
                                              }
                                              debugPrint("favorite $favorite");
                                            });
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            color: favorite
                                                ? Styles.primaryRed
                                                : Colors.white,
                                            size: 30,
                                          ));
                                    })))
                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: widget.width - 25,
                      child: Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.place.name,
                                    style: Styles.placeH1,
                                  ),
                                ),
                                Text(
                                  widget.place.price.toString() + '€',
                                  style: Styles.placeRedH1,
                                ),
                              ],
                            ),
                          ),
                          Text('Sopivuus ' + widget.place.adequacy + '%',
                              style: TextStyle(color: Styles.primaryRed)),
                          Row(children: <Widget>[
                            const Icon(Icons.location_on_outlined,
                                color: Colors.black, size: 15),
                            Text(
                                widget.place.address + ', ' + widget.place.city,
                                style: Styles.placeH2),
                          ]),
                          Row(children: <Widget>[
                            const Icon(Icons.access_time_outlined,
                                color: Colors.black, size: 15),
                            Text(widget.place.time, style: Styles.placeH2),
                          ]),
                          if (widget.place.services.isNotEmpty) ...[
                            const Text('Lisäpalvelut', style: Styles.placeH1),
                            const Text('Valitse haluamasi lisäpalvelut'),
                            for (Service service in widget.place.services)
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (service.iconColor == Colors.black) {
                                        price += service.price;
                                        service.iconColor = Styles.primaryRed;
                                        services.add(service.toString());
                                      } else {
                                        services.remove(service.toString());
                                        service.iconColor = Colors.black;
                                        price -= service.price;
                                      }
                                    });
                                  },
                                  child: ListTile(
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
                                            color: Colors.pink[100],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Icon(service.icon,
                                            color: service.iconColor,
                                            size: 30)),
                                  )),
                          ],
                          if (widget.place.info != '') ...[
                            const Text('Tilan yleistiedot',
                                style: Styles.placeH1),
                            Text(widget.place.info)
                          ],
                          if (widget.place.usageInfo != '') ...[
                            const Text('Ohjeistus tilan käyttöön',
                                style: Styles.placeH1),
                            Text(widget.place.usageInfo)
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              )),
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
                              place.totalPrice = 0;
                              place.services = services.join(',');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReservePage(
                                          place: place,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Styles.primaryRed,
                                fixedSize: const Size(180, 60),
                                shape: const StadiumBorder()),
                            child: const Text('Varaa tila',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Column(
                            children: <Widget>[
                              const Text('Kokonaishinta',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                price.toString() + '€',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.primaryRed),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ]),
          ),
        ));
  }
}
