import 'package:flutter/material.dart';

cleaningService(int price) {
  return Service(
      text: 'Tilan loppusiivous',
      price: price,
      icon: Icons.cleaning_services_outlined);
}

organiser(int price) {
  return Service(
      text: 'Juhlanjärjestäjä', price: price, icon: Icons.person_outlined);
}

drinkService(int price) {
  return Service(
      text: 'Virvoketarjoilu', price: price, icon: Icons.local_drink_outlined);
}

customService(String text, int price, IconData icon) {
  return Service(text: text, price: price, icon: icon);
}

class Service {
  String text;
  int price;
  IconData icon;
  Color iconColor = Colors.black;
  Service({required this.text, required this.price, required this.icon});

  @override
  String toString() {
    return '$price:$text:${icon.codePoint}';
  }
}
