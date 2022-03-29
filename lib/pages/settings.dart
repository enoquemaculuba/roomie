// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:roomie/roomie_icons.dart';
import 'package:roomie/styles.dart';
import 'package:roomie/widgets/util.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(name: 'Asetukset', context: context),
      body: const Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => SettingsStateful();
}

class SettingsStateful extends State<Settings> {
  bool notificationsOn = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      //TODO add functionality here. Settings should actually do something :D
      Text('Mieltymykset', style: Styles.textBold),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text('Juhlatilat', style: Styles.bold),
      ),
      CustomSlider(),
      Text('Saunatilat', style: Styles.bold),
      CustomSlider(),
      Text('Opiskelutilat', style: Styles.bold),
      CustomSlider(),
      Text('Työskentelytilat', style: Styles.bold),
      CustomSlider(),
      Text('Liikuntatilat', style: Styles.bold),
      CustomSlider(),
      Text('Varastotilat', style: Styles.bold),
      CustomSlider(),
      Text('Mökit', style: Styles.bold),
      CustomSlider(),
// TODO implement a way to add multiple payment methods
      Text('Maksutiedot', style: Styles.textBold),
      Stack(
        children: [
          Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Styles.primaryRed,
                shape: BoxShape.circle,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 200, top: 60),
            child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Styles.primaryRed,
                  shape: BoxShape.circle,
                )),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: 270,
                height: 150,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(56, 56, 56, 0.4),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'OP',
                            style: Styles.cardH1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.credit_card_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'xxxx-xxxx-xxxx',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: const <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text('VALID UNTIL xx/xx',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text('Teemu Teekkari',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 30, bottom: 10),
                            child: Icon(Roomie.visa, color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Center(
        child: ElevatedButton(
          onPressed: () {},
          child: SizedBox(
            height: 40,
            width: 150,
            child: Center(
              child: const Text(
                "Poista kortti",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Styles.primaryRed,
            shadowColor: Colors.transparent,
            shape: const StadiumBorder(),
          ),
        ),
      ),
      Text('Yleisasetukset', style: Styles.textBold),
      CustomSwitch(text: 'Salli ilmoitukset'),
      CustomSwitch(
          text:
              'Annan sovellukselle luvan käyttää palautettani datan oikeellisuudesta ja suositusten hyvyydestä sovelluksen kehittämisessä. Palaute on anonyymiä.'),
      SizedBox(
        width: 150,
        child: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: SizedBox(
              height: 60,
              width: 200,
              child: Center(
                child: const Text(
                  "Kirjaudu ulos",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Styles.primaryRed,
              shadowColor: Colors.transparent,
              shape: const StadiumBorder(),
            ),
          ),
        ),
      )
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
