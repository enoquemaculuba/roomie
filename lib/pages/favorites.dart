import 'package:flutter/material.dart';
import 'package:roomie/util/DatabaseHelper.dart';
import 'package:roomie/widgets/util.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: 'Suosikit', context: context),
        body: FavoritesMain());
  }
}

class FavoritesMain extends StatelessWidget {
  FavoritesMain({Key? key}) : super(key: key);

  Future<List<PlaceCard>> getList() async {
    return await DatabaseHelper.instance.favoriteToPlaceCard();
  }

  final List<PlaceCard> favList = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int widthCard = (200);
    int countRow = width ~/ widthCard;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: SearchBar(
            null,
            text: 'Etsi suosikeista...',
            searchFrom: favList,
          ),
        ),
        Expanded(
            child: FutureBuilder<List<PlaceCard>>(
                future: getList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    for (var element in snapshot.data!) {
                      if (!favList.contains(element)) {
                        favList.add(element);
                      }
                    }
                    return GridView.count(
                      primary: false,
                      padding:
                          const EdgeInsets.only(top: 30, left: 30, right: 30),
                      crossAxisCount: countRow,
                      childAspectRatio: 0.80,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: snapshot.data!
                          .toList()
                          .map((e) => placeClick(e, context))
                          .toList(),
                      shrinkWrap: true,
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/pic1.PNG'),
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('Sinulla ei ole vielä suosikkeja'),
                        )
                      ],
                    );
                  }
                })),
      ],
    );
  }
}
