// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:roomie/util/DatabaseHelper.dart';
import 'package:roomie/util/services.dart';
import 'package:roomie/widgets/util.dart';

class Place {
  final int id;
  final String name;
  final String address;
  final String reservationTime;
  final String startTime;
  final String endTime;
  final String services;
  final int price;

  Place(
      {required this.id,
      required this.name,
      required this.address,
      required this.reservationTime,
      required this.startTime,
      required this.endTime,
      required this.services,
      required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'reservationTime': reservationTime,
      'startTime': startTime,
      'endTime': endTime,
      'services': services,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'Place{id: $id name: $name address $address reservation time: $reservationTime starting time: $startTime, ending time: $endTime services $services total price $price}';
  }
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

class PlaceWrapper {
  PlaceCard placeCard;

  int totalPrice = 0;

  String _reservationTime = "";

  String get reservationTime {
    return _reservationTime;
  }

  set reservationTime(String newTime) {
    _reservationTime = newTime;
  }

  DateTime? startTime;
  DateTime? endTime;

  int get price {
    return totalPrice;
  }

  set price(int newPrice) {
    totalPrice = newPrice;
  }

  int getServicesPrice() {
    if (_services != '') {
      List<Service> services = parseService(_services);
      return services.map((e) => e.price).reduce((a, b) => a + b);
    }
    return 0;
  }

  int getTotalPrice() {
    return getServicesPrice() + totalPrice;
  }

  String _services = '';

  String get services {
    return _services;
  }

  set services(String a) {
    _services = a;
  }

  PlaceWrapper({required this.placeCard, required this.totalPrice});
}

void main() async {
  await DatabaseHelper.instance.insertPlace(Place(
      id: 0,
      name: 'Pyörösauna',
      address: 'Kaaritie 12',
      reservationTime: DateTime.now().toString(),
      startTime: '12:00',
      endTime: '16:00',
      services: '',
      price: 200));

  int id = await DatabaseHelper.instance.getLastID();

  debugPrint("last index: " + id.toString());
}
