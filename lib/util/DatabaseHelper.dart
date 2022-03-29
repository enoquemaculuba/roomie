// ignore_for_file: file_names
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:roomie/util/places.dart';
import 'package:roomie/util/reservation_system.dart';
import 'package:roomie/widgets/util.dart';

/*
class DatabaseHelper2 {
  static const _databaseName = "place.db";
  static const _databaseVersion = 1;

  DatabaseHelper2._privateConstructor();
  static final DatabaseHelper2 instance = DatabaseHelper2._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE IF NOT EXISTS favorites(place TEXT PRIMARY KEY)');
        return db.execute(
          'CREATE TABLE IF NOT EXISTS place(id INTEGER  PRIMARY KEY, name TEXT, address TEXT, reservationTime TEXT, startTime TEXT,endTime TEXT, services TEXT, price INTEGER)',
        );
      },
      version: _databaseVersion,
    );
    return await database;
  }

  bool isNumeric(String str) {
    if (str == null.toString()) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  Future<int> getLastId() async {
    Database db = await instance.database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM place");
    var res = table.first['id'];
    var id = isNumeric(res.toString()) ? res as int : 0;
    return id;
  }

  Future<List<Place>> places() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('place');
    return List.generate(maps.length, (i) {
      return Place(
        id: maps[i]['id'],
        name: maps[i]['name'],
        address: maps[i]['address'],
        reservationTime: maps[i]['reservationTime'],
        startTime: maps[i]['startTime'],
        endTime: maps[i]['endTime'],
        services: maps[i]['services'],
        price: maps[i]['price'],
      );
    });
  }

  Future<List<PlaceWrapper>> placeToPlaceWrapper() async {
    var placeList = await places();
    var _services = services();
    print(await places());
    List<PlaceWrapper> result = [];
    for (Place p in placeList) {
      var res = _services.firstWhereOrNull(
          (element) => element.name == p.name && element.address == p.address);
      if (res != null) {
        var _placeWrapper = PlaceWrapper(placeCard: res, totalPrice: p.price);
        _placeWrapper.services = p.services;
        _placeWrapper.endTime = mainFormatter.parse(p.endTime);
        _placeWrapper.startTime = mainFormatter.parse(p.startTime);
        _placeWrapper.reservationTime = p.reservationTime;
        result.add(_placeWrapper);
      }
    }
    return result;
  }

  Future<void> insertPlace(Place place) async {
    Database db = await instance.database;
    await db.insert(
      'place',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFavorite(String text) async {
    Database db = await instance.database;
    await db.insert(
      'favorites',
      {'place': text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(String text) async {
    Database db = await instance.database;
    await db.delete(
      'favorites',
      where: 'place = ?',
      whereArgs: [text],
    );
  }

  Future<List<String>> getFavorites() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return maps[i]['place'];
    });
  }

  Future<List<Map<String, Object?>>> getFavorite(String text) async {
    Database db = await instance.database;
    var res =
        await db.query('favorites', where: 'place = ?', whereArgs: [text]);
    return res;
  }

  Future<List<PlaceCard>> favoriteToPlaceCard() async {
    var placeList = await getFavorites();
    var _services = services();
    List<PlaceCard> result = [];
    for (String p in placeList) {
      var string = p.split(':');
      var res = _services.firstWhereOrNull((element) =>
          element.name == string[0] && element.address == string[1]);
      if (res != null) {
        result.add(res);
      }
    }
    return result;
  }

  Future<void> reservationToDb(PlaceWrapper placeWrapper) async {
    int id = await getLastId() + 1;
    var p = placeWrapper.placeCard;
    Place place = Place(
      id: id,
      price: placeWrapper.price,
      address: p.address,
      name: p.name,
      reservationTime: placeWrapper.reservationTime,
      startTime: placeWrapper.startTime!.toString(),
      endTime: placeWrapper.endTime!.toString(),
      services: placeWrapper.services,
    );
    insertPlace(place);
  }

  Future<void> updatePlace(Place place) async {
    Database db = await instance.database;
    await db.update(
      'place',
      place.toMap(),
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  Future<void> deletePlace(int id) async {
    Database db = await instance.database;
    await db.delete(
      'place',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
*/

class DatabaseHelper {
  final LocalStorage storage = LocalStorage('data');

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<bool> initDB() async {
    return await storage.ready;
  }

  bool isNumeric(String str) {
    if (str == null.toString()) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  Future<List<Place>> places() async {
    await storage.ready;
    try {
      List<dynamic> maps = storage.getItem('place');
      return List.generate(maps.length, (i) {
        return Place(
          id: maps[i]['id'],
          name: maps[i]['name'],
          address: maps[i]['address'],
          reservationTime: maps[i]['reservationTime'],
          startTime: maps[i]['startTime'],
          endTime: maps[i]['endTime'],
          services: maps[i]['services'],
          price: maps[i]['price'],
        );
      });
    } catch (e, stacktrace) {
      debugPrintStack(stackTrace: stacktrace, label: 'Error: $e');
      return [];
    }
  }

  Future<List<PlaceWrapper>> placeToPlaceWrapper() async {
    try {
      var placeList = await places();
      var _services = services();
      List<PlaceWrapper> result = [];
      for (Place p in placeList) {
        var res = _services.firstWhereOrNull((element) =>
            element.name == p.name && element.address == p.address);
        if (res != null) {
          var _placeWrapper = PlaceWrapper(placeCard: res, totalPrice: p.price);
          _placeWrapper.services = p.services;
          _placeWrapper.endTime = mainFormatter.parse(p.endTime);
          _placeWrapper.startTime = mainFormatter.parse(p.startTime);
          _placeWrapper.reservationTime = p.reservationTime;
          result.add(_placeWrapper);
        }
      }
      return result;
    } catch (e, stacktrace) {
      debugPrintStack(stackTrace: stacktrace, label: 'Error: $e');
      return [];
    }
  }

  Future<List<dynamic>> addToPlace(Place place) async {
    await storage.ready;
    List<dynamic> list = await storage.getItem('place') ?? [];
    list.add(place.toMap());
    return list;
  }

  Future<void> insertPlace(Place place) async {
    await storage.ready;
    List<dynamic> list = await addToPlace(place);
    storage.setItem('place', list);
  }

  Future<void> removePlace(Place place) async {
    await storage.ready;
    List<dynamic> list = await storage.getItem('place') ?? [];
    list.remove(place.toMap());
    storage.setItem('place', list);
  }

  Future<int> getLastID() async {
    await storage.ready;
    if (storage.getItem('id') == null) {
      await storage.setItem('id', 0);
    }
    return await storage.getItem('id');
  }

  Future<List<String>> addFavorite(String text) async {
    await storage.ready;
    List<dynamic> list = await storage.getItem('favorites') ?? [];
    if (!list.contains(text)) {
      list.add(text);
    }
    return list.cast<String>();
  }

  Future<void> insertFavorite(String text) async {
    await storage.ready;
    List<dynamic> list = await addFavorite(text);
    storage.setItem('favorites', list);
  }

  Future<void> deleteFavorite(String text) async {
    await storage.ready;
    List<dynamic> list = await storage.getItem('favorites');
    list.remove(text);
    storage.setItem('favorites', list);
  }

  Future<List<String>> getFavorites() async {
    try {
      await storage.ready;
      List<dynamic> list = await storage.getItem('favorites');
      return list.cast<String>();
    } catch (e, stacktrace) {
      debugPrintStack(stackTrace: stacktrace, label: 'Error: $e');
      return [];
    }
  }

  Future<List<Map<String, Object?>>> getFavorite(String text) async {
    try {
      await storage.ready;
      Map<String, dynamic> maps = storage.getItem('place');
      return [maps];
    } catch (e, stacktrace) {
      debugPrintStack(stackTrace: stacktrace, label: 'Error: $e');
      return [];
    }
  }

  Future<List<PlaceCard>> favoriteToPlaceCard() async {
    try {
      var placeList = await getFavorites();
      var _services = services();
      List<PlaceCard> result = [];
      for (String p in placeList) {
        var string = p.split(':');
        var res = _services.firstWhereOrNull((element) =>
            element.name == string[0] && element.address == string[1]);
        if (res != null) {
          result.add(res);
        }
      }
      return result;
    } catch (e, stacktrace) {
      debugPrintStack(stackTrace: stacktrace, label: 'Error: $e');
      return [];
    }
  }

  Future<void> reservationToDb(PlaceWrapper placeWrapper) async {
    int id = await getLastID() + 1;
    var p = placeWrapper.placeCard;
    Place place = Place(
      id: id,
      price: placeWrapper.getTotalPrice(),
      address: p.address,
      name: p.name,
      reservationTime: placeWrapper.reservationTime,
      startTime: placeWrapper.startTime!.toString(),
      endTime: placeWrapper.endTime!.toString(),
      services: placeWrapper.services,
    );
    insertPlace(place);
  }
}
