import 'package:flutter/material.dart';
import 'package:roomie/main.dart';
import 'package:roomie/widgets/util.dart';

import '../styles.dart';

class PaymentPage extends StatelessWidget {
  final String name;
  const PaymentPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: name, context: context),
        body: const PaymentMain());
  }
}

class PaymentMain extends StatelessWidget {
  const PaymentMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<String> _calculation = Future<String>.delayed(
      const Duration(seconds: 2),
      () => 'Data Loaded',
    );

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline5!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _calculation, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Varauksesi onnistui!')),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Tilausvahvistus kolahtaa tuota pikaa sähköpostiisi! Toivottavasti asiointisi sujui jouhevasti ja mukavasti!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              button(context)
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Virhe maksussa'),
              ),
              button(context),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Käsitellään maksua...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}

Widget button(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Route route = MaterialPageRoute(builder: (context) => const MyApp());
        Navigator.pushReplacement(context, route);
        /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyApp()));*/
      },
      style: ElevatedButton.styleFrom(
          primary: Styles.primaryRed, shape: const StadiumBorder()),
      child: const Text('Palaa pääsivulle',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ),
  );
}
