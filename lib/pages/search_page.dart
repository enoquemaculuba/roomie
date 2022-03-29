import 'package:flutter/material.dart';
import 'package:roomie/widgets/util.dart';
import 'package:collection/collection.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:roomie/util/globals.dart' as globals;

class SearchPage extends StatelessWidget {
  final String searchString;
  final List<PlaceCard> searchFrom;
  final List<CategoryButton>? categories;
  const SearchPage(
      {Key? key,
      required this.searchString,
      required this.searchFrom,
      required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(name: 'Hakutulokset', context: context),
        body: SearchMain(
            keyword: searchString,
            searchFrom: searchFrom,
            categories: categories));
  }
}

class SearchMain extends StatelessWidget {
  final String keyword;
  final List<PlaceCard> searchFrom;
  final List<CategoryButton>? categories;
  const SearchMain(
      {Key? key,
      required this.keyword,
      required this.searchFrom,
      required this.categories})
      : super(key: key);

  bool find(PlaceCard card, String search) {
    if (card.price < globals.minPrice || card.price > globals.maxPrice) {
      return false;
    }
    if (search == '') {
      return true;
    }
    var list = [card.address, card.info, card.name, card.usageInfo, card.type];

    for (String s in list) {
      if (s.similarityTo(search) >= 0.4) {
        return true;
      }
    }
    var keys = card.name.split(' ');
    var searchWords = search.split(' ');
    for (String word in searchWords) {
      var regex = RegExp("\\b(?:${keys.join('|')})\\b", caseSensitive: false);
      if (card.type.toLowerCase() == word ||
          regex.hasMatch(word) ||
          card.name.toLowerCase().contains(word) ||
          card.type.toLowerCase().contains(word) ||
          card.info.toLowerCase().contains(word) ||
          card.city.toLowerCase() == word ||
          card.address.toLowerCase().contains(word)) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    CategoryButton? category;
    if (categories != null) {
      category = categories!.firstWhereOrNull((element) => element.isSelected);
    }

    var list = categories != null && category != null
        ? searchFrom.where((x) => category!.text.similarityTo(x.type) >= 0.7)
        : searchFrom;
    double width = MediaQuery.of(context).size.width;
    int widthCard = (200);
    int countRow = width ~/ widthCard;
    var found =
        list.where((element) => find(element, keyword.toLowerCase())).toList();
    if (found.isEmpty) {
      return const Center(
          child: Text(
        'Pahuus... Tilaa ei löytynyt',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    } else {
      return GridView.count(
        primary: false,
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        crossAxisCount: countRow,
        childAspectRatio: 0.80,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children:
            found.map((e) => placeClick(e, context)).toList(), //new Cards()
        shrinkWrap: true,
      );
    }
  }
}
